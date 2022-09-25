help:
	@echo "read the Makefile"

darwin-bootstrap-a:
	xcode-select --install || true
	curl -L https://nixos.org/nix/install | sh
	@echo "Done. Run a new shell and type 'make darwin-bootstrap-b"

darwin-bootstrap-b:
	nix-env -iA nixpkgs.nixVersions.stable
	nix --experimental-features 'nix-command flakes' build .#darwinConfigurations.macbook.system
