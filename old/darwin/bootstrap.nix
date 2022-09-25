{ config, pkgs, lib, ... }:

{
  # Nix configuration ------------------------------------------------------------------------------

  nix.binaryCaches = [
    "https://cache.nixos.org/"
    "https://iohk.cachix.org"
    "https://hydra.iohk.io"
    "https://gfanton.cachix.org"
    "https://moul.cachix.org"
  ];
  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    "gfanton.cachix.org-1:i8zC+UjhhW5Wx2iRibhexJeBb1jOU/8oRFGG60IaAmI="
    "moul.cachix.org-1:jcmTECmIfe9zam+p4sP3RhEXmH7QTTChd9ax/vo1CYs="
  ];
  nix.trustedUsers = [ "@admin" ];
  users.nix.configureBuildUsers = true;

  # Enable experimental version of nix with flakes support
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Shells -----------------------------------------------------------------------------------------

  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [ bashInteractive zsh ];

  # Install and setup ZSH to work with nix(-darwin) as well
  programs.zsh.enable = true;
  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
