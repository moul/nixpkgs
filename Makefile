#
# PUBLIC
#

all: switch

# smart switch
HOST ?= $(shell hostname)
ifeq ($(HOST),moul-mini-1.local)                    # mac, m1, desktop
switch: _info switch.desktop-aarch64

else ifeq ($(HOST),fwrz)                            # linux, x86_64, server
switch: _info switch.linux-x86_64

else ifeq ($(HOST),manfred-imac-2.local)            # mac, x86_64, desktop
switch: _info switch.desktop-x86_64

else ifeq ($(HOST),manfred-spacegray-3.local)       # mac, x86_64, desktop
switch: _info switch.desktop-x86_64

else ifeq ($(HOST),moul-vp-linux)                   # linux, x86_64, desktop
switch: _info switch.linux-x86_64

else
switch:
	$(error "unknown hostname: $(HOST), you can call a switch.SOMETHING rule manually.")
endif
# end

test:
	docker run -v "$(PWD):/root/dotfiles" -w /root/dotfiles -it --rm nixos/nix \
		nix-shell -p stow --run 'make install-flake setup-cachix _setup USER=dockerTest'

fmt:
	nixfmt `find . ! -path './home-manager/*' ! -path './.git/*' -name "*.nix"`

diff:
	@set -e; \
	cd /nix/var/nix/profiles/per-user/moul; \
	current_version=`ls | grep home-manager- | sed 's/home-manager-\(.*\)-link/\1/' | sort -n | tail -n 1`; \
	previous_version=`ls | grep home-manager- | sed 's/home-manager-\(.*\)-link/\1/' | sort -n | tail -n 2 | head -n 1`; \
	nix-diff `nix-store -qd home-manager-$$previous_version-link home-manager-$$current_version-link`; \
	echo "previous_version: $$previous_version, current_version: $$current_version"

gc:
	nix-env -p /nix/var/nix/profiles/system --delete-generations +1
	nix-collect-garbage -d

update:
	#nix-channel --update
	nix flake update

#
# INTERNAL
#

_info:
	@echo ============
	@echo = INFO
	@echo ============
	@sh -xc " \
		hostname || true; \
		uname -a || true; \
		nix --version || true; \
		id || true; \
	"

SETENV = . ~/.nix-profile/etc/profile.d/nix.sh
_setup:
	mkdir -p ~/.config
	ln -sf $(PWD) ~/.config/nixpkgs
	#$(SETENV); nix build .#moul.activationPackage
	$(SETENV); nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	$(SETENV); nix-channel --update
	$(SETENV); home-manager switch

install-darwin:
	xcode-select --install || true
	curl -L https://nixos.org/nix/install > /tmp/nix-install
	sh /tmp/nix-install --darwin-use-unencrypted-nix-store-volume --daemon
	. /Users/moul/.nix-profile/etc/profile.d/nix.sh && nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
	./result/bin/darwin-installer
	rm -rf result /tmp/nix-install

install-linux-root:
	curl -L https://nixos.org/nix/install > /tmp/nix-install
	sh /tmp/nix-install
	make _setup


install-linux-no-root:
	unshare --user --pid echo YES | grep -q YES
	mkdir -p -m 0755 ~/.nix
	wget "https://github.com/nix-community/nix-user-chroot/releases/download/1.2.1/nix-user-chroot-bin-1.2.1-x86_64-unknown-linux-musl" -N -O ~/.nix/nix-user-chroot
	chmod +x ~/.nix/nix-user-chroot
	~/.nix/nix-user-chroot ~/.nix bash -c "curl -L https://nixos.org/nix/install | bash"
	~/.nix/nix-user-chroot ~/.nix make _setup
	echo "exec ~/.nix/nix-user-chroot ~/.nix ~/.nix-profile/bin/zsh -l" > ~/nixsh
	chmod 711 ~/nixsh
	~/.nix/nix-user-chroot ~/.nix make apply

install-flake:
	nix-env -iA nixpkgs.nixFlakes
	nix-env -iA nixpkgs.curl || true
	nix-env -iA nixpkgs.git || true
	if [ ! -f ~/.config/nix/nix.conf ]; then \
		mkdir -p ~/.config/nix; \
		echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf; \
	fi
	curl -L https://github.com/numtide/nix-flakes-installer/releases/download/nix-3.0pre20200804_ed52cf6/install | sh

setup-cachix:
	nix-env -iA cachix -f https://cachix.org/api/v1/install
	cachix use nix-community

regen-emacs:
	raw-emacs --batch --load=~/.spacemacs -debug-init
	#raw-emacs --eval='(configuration-layer/load)' --quit --debug-init
	raw-emacs --no-site-file --batch --load=~/.spacemacs --eval="(package-initialize)"

switch.desktop-x86_64:
	@echo ============
	@echo = SWITCH: MAC, X86_64, DESKTOP
	@echo ============
	nix build .#darwinConfigurations.bootstrap-x86_64.system
	./result/sw/bin/darwin-rebuild switch --verbose --flake .#desktop-x86_64

switch.desktop-aarch64:
	@echo ============
	@echo = SWITCH: MAC, AARCH64, DESKTOP
	@echo ============
	nix build .#darwinConfigurations.bootstrap-aarch64.system
	./result/sw/bin/darwin-rebuild switch --verbose --flake .#desktop-aarch64

switch.linux-x86_64:
	@echo ============
	@echo = SWITCH: LINUX, X86_64, SERVER/DESKTOP
	@echo ============
	#nix build .#linuxConfigurations.bootstrap-x86_64.system
	nix build .#linuxConfigurations.server-x86_64.activationPackage
	./result/activate switch --verbose --flake .#linux-x86_64

killall-osx:
	@killall "Activity Monitor" || true
	@killall "Address Book" || true
	@killall "Calendar" || true
	@killall "Contacts" || true
	@killall "cfprefsd" || true
	@killall "Dock" || true
	@killall "Finder" || true
	@killall "Mail" || true
	@killall "Messages" || true
	@killall "Safari" || true
	@killall "SizeUp" || true
	@killall "SystemUIServer" || true
	@killall "Terminal" || true
	@killall "Transmission" || true
	@killall "Twitter" || true
	@killall "iCal" || true

fix-darwin-daemon-permissions:
	sudo chown -R root:nixbld /nix
	sudo chmod 1777 /nix/var/nix/profiles/per-user
	sudo chown -R $$USER:staff /nix/var/nix/profiles/per-user/$$USER
	sudo mkdir -m 1777 -p /nix/var/nix/gcroots/per-user
	sudo chown -R $$USER:staff /nix/var/nix/gcroots/per-user/$$USER
