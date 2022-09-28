{
  allowUnfree = true;
  allowUnsupportedSystem = true;
  packageOverrides = pkgs: rec {
    home-manager = import ./home-manager { inherit pkgs; };
  };
}
