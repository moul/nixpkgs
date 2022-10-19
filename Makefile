HOSTNAME ?= `hostname | sed s/\\.local//`
UNAME_S := $(shell uname -s)
DARWIN_HOSTS = moul-musca moul-volans moul-pyxis
LINUX_HOSTS = fwrz zrwf

all: switch cachix-push

switch:
	@echo "Trying to guess what to do..."
	@sh -xec "make $(HOSTNAME)"

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

linux-bootstrap-b darwin-bootstrap-b:
	nix-env -iA nixpkgs.nixVersions.stable

$(DARWIN_HOSTS):
	nix --experimental-features 'nix-command flakes' build .#darwinConfigurations.$@.system
	./result/sw/bin/darwin-rebuild switch --flake .#$@
	@echo Done.

$(LINUX_HOSTS):
	nix --experimental-features 'nix-command flakes' build .#homeConfigurations.$@.activationPackage
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
