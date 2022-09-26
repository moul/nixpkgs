HOSTNAME ?= `hostname`
UNAME_S := $(shell uname -s)


all: switch

switch:
	@echo "Trying to guess what to do..."
	@sh -xec "make $(HOSTNAME)"

help:
	@echo "read the Makefile"

darwin-bootstrap-a:
	xcode-select --install || true
	curl -L https://nixos.org/nix/install | sh
	@echo "Done. Run a new shell and type 'make darwin-bootstrap-b"

darwin-bootstrap-b:
	nix-env -iA nixpkgs.nixVersions.stable

moul-musca:
	nix --experimental-features 'nix-command flakes' build .#darwinConfigurations.$@.system
	./result/sw/bin/darwin-rebuild switch --flake .#$@
	@echo Done.

cachix-push:
ifeq ($(UNAME_S),Linux)
	-nix path-info ".#linuxConfigurations.$(HOSTNAME).activationPackage" | cachix push moul || true
endif
ifeq ($(UNAME_S),Darwin)
	-nix path-info ".#darwinConfigurations.$(HOSTNAME).system" | cachix push moul || true
endif
	nix flake archive --json | jq -r '.path,(.inputs|to_entries[].value.path)' | cachix push moul

