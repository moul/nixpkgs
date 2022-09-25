help:
	@echo "read the Makefile"

darwin-bootstrap-a:
	xcode-select --install || true
	curl -L https://nixos.org/nix/install | sh
	@echo "Done. Run a new shell and type 'make darwin-bootstrap-b"

darwin-bootstrap-b:
	nix-env -iA nixpkgs.nixVersions.stable

musca:
	nix --experimental-features 'nix-command flakes' build .#darwinConfigurations.$@.system
	./result/sw/bin/darwin-rebuild switch --flake .#$@
