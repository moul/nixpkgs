{ config, pkgs, lib, ... }:

{
  imports = [
    # Minimal config of Nix related options and shells
    ./bootstrap.nix
    ./system-defaults.nix

    # Other nix-darwin configuration
    # @FIXME: this is taking too much time
    # ./homebrew.nix
  ];

  # Networking
  #networking.dns = [
  #  "1.1.1.1"
  #  "8.8.8.8"
  #];

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [ kitty terminal-notifier ];

  environment.pathsToLink = [ "/share/terminfo" ];

  # https://github.com/nix-community/home-manager/issues/423
  environment.variables = {
    TERMINFO_DIRS = "${config.system.path}/share/terminfo";
  };

  # Fonts
  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" "FiraCode" ]; })
  ];

  # Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;

  # Lorri daemon
  # https://github.com/target/lorri
  # Used in conjuction with Direnv which is installed in `../home/default.nix`.
  services.lorri.enable = true;

  # emacs daemon
  # services.emacsd = {
  #   package = pkgs.emacsGcc;
  #   enable = true;
  # };
}
