
HOSTNAME ?= `hostname | cut -d. -f1`
UNAME_S := $(shell uname -s)
DARWIN_HOSTS = moul-musca moul-volans moul-pyxis moul-triangulum moul-scutum moul-fornax moul-dorado
LINUX_HOSTS = fwrz zrwf crux pictor lyra

all: switch reload_all cachix-push

switch:
	@echo "Trying to guess what to do..."
	@sh -xec "make $(HOSTNAME)"

switch.offline:
	@echo "Trying to guess what to do..."
	@sh -xec "make $(HOSTNAME).offline"

help:
	@echo "read the Makefile"

update:
	nix flake update

gc:
	nix-collect-garbage -d

repair:
	nix-store --verify --repair --check-contents

linux-bootstrap-a:
	curl -L https://nixos.org/nix/install | sh

darwin-bootstrap-a:
	xcode-select --install || true
	curl -L https://nixos.org/nix/install | sh
	@echo "Done. Run a new shell and type 'make darwin-bootstrap-b"

darwin-cleanup:
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]
	@echo -n "Are you really sure? [y/N] " && read ans && [ $${ans:-N} = y ]
	@echo -n "Are you really really sure? [y/N] " && read ans && [ $${ans:-N} = y ]
	sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist || true
	sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist || true
	sudo mv /etc/profile.backup-before-nix /etc/profile || true
	sudo mv /etc/bashrc.backup-before-nix /etc/bashrc || true
	sudo mv /etc/zshrc.backup-before-nix /etc/zshrc || true
	sudo rm -rf /etc/nix /nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels /Users/$(USER)/.nix-profile /Users/$(USER)/.nix-defexpr /Users/$(USER)/.nix-channels || true

linux-bootstrap-b darwin-bootstrap-b:
	nix-env -iA nixpkgs.nixVersions.stable

$(DARWIN_HOSTS):
	nix --experimental-features 'nix-command flakes ca-derivations ca-references' build .#darwinConfigurations.$@.system
	./result/sw/bin/darwin-rebuild switch --flake .#$@
	@echo Done.

$(patsubst %,%.offline,$(DARWIN_HOSTS)):
	# TODO: disable homebrew too.
	nix --experimental-features 'nix-command flakes ca-derivations ca-references' build .#darwinConfigurations.$(patsubst %.offline,%,$@).system --option substitute false
	./result/sw/bin/darwin-rebuild switch --flake $(patsubst %.offline,%,.#$@)
	@echo Done.

$(LINUX_HOSTS):
	nix --experimental-features 'nix-command flakes ca-derivations ca-references' build .#homeConfigurations.$@.activationPackage
	./result/activate
	@echo Done.

fmt:
	nixfmt `find . ! -path './old/*' ! -path './.git/*' -name "*.nix"`

cachix-push:
ifeq ($(UNAME_S),Linux)
	-nix path-info ".#homeConfigurations.$(HOSTNAME).activationPackage" | cachix push moul || true
endif
ifeq ($(UNAME_S),Darwin)
	-nix path-info ".#darwinConfigurations.$(HOSTNAME).system" | cachix push moul || true
endif
	nix flake archive --json | jq -r '.path,(.inputs|to_entries[].value.path)' | cachix push moul
	@echo Done.

###

reload_all:
	@echo "Trying to guess what to do..."
	@sh -xec "make $(HOSTNAME).reload_all"

$(patsubst %,%.reload_all,$(DARWIN_HOSTS)): reload_all_darwin
$(patsubst %,%.reload_all,$(LINUX_HOSTS)): reload_all_linux

reload_all_darwin: reload_kitty reload_ubersicht reload_finder
reload_all_linux:
reload_kitty:; pkill -USR1 kitty
#reload_skhd:;  $(call restart_service,org.nixos.yabai.plist)
#reload_yabai:; $(call restart_service,org.nixos.skhd.plist)
reload_ubersicht:; osascript -e 'tell application "Übersicht" to reload'; osascript -e 'tell application "Übersicht" to refresh'
reload_finder:; killall Finder

#define restart_service
#	@set -e; plist_path=`find "${HOME}/Library/LaunchAgents" -name "$(1)" 2>/dev/null | head -n 1`; \
#	((set -x; sudo launchctl bootout system "$$plist_path") || true); \
#	(set -x; sudo launchctl bootstrap system "$$plist_path")
#endef

build_emacs:
	raw-emacs --batch -L ~/.emacs.d/core -L ~/.emacs.d/layers -l ~/.emacs.d/core/core-load-paths.el -l ~/.emacs.d/core/core-versions.el --eval '(batch-byte-recompile-directory 0)' ~/.emacs.d/core
	raw-emacs --batch --eval '(batch-byte-recompile-directory 0)' ~/.emacs.d/layers
	raw-emacs --batch --eval '(batch-byte-compile)' ~/.emacs.d/*.el

nix-info:
	nix-shell -p nix-info --run "nix-info -m"

nix-store-verify:
	nix store verify --recursive \
	  --experimental-features nix-command \
	  --sigs-needed 10000 \
	  /run/current-system

