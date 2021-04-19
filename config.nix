{
  allowUnfree = true;
  allowBroken = true;
  allowUnsupportedSystem = true;
  packageOverrides = pkgs: rec {
    home-manager = import ./home-manager { inherit pkgs; };
  };
  permittedInsecurePackages = [
    "openssl-1.0.2u"
  ];
}
