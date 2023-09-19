{ config, lib, pkgs, ... }:

{
  # Nix configuration ------------------------------------------------------------------------------

  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://iohk.cachix.org"
      "https://hydra.iohk.io"
      "https://gfanton.cachix.org"
      "https://moul.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      "gfanton.cachix.org-1:i8zC+UjhhW5Wx2iRibhexJeBb1jOU/8oRFGG60IaAmI="
      "moul.cachix.org-1:jcmTECmIfe9zam+p4sP3RhEXmH7QTTChd9ax/vo1CYs="
    ];

    trusted-users = [ "@admin" ];

    auto-optimise-store = true;

    experimental-features = [ "nix-command" "flakes" ];

    keep-outputs = true;
    keep-derivations = true;

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };

  nix.configureBuildUsers = true;

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
