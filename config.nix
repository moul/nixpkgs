{
  allowUnfree = true;
  allowBroken = true;
  allowUnsupportedSystem = true;
  packageOverrides = pkgs: rec {
    home-manager = import ./home-manager { inherit pkgs; };
  };
  permittedInsecurePackages = [
    "openssl-1.0.2u"
    "libsixel-1.8.6"
    "adobe-reader-9.5.5-1"
    "autotrace-0.31.1"
  ];
}
