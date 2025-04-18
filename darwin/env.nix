{ pkgs, ... }:

{
  # Networking
  # networking.dns = [ ];

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [ kitty terminal-notifier ];

  # https://github.com/nix-community/home-manager/issues/423
  environment.variables = {
    # TERMINFO_DIRS = "${pkgs.pkgs-stable.kitty.terminfo.outPath}/share/terminfo";
  };
  programs.nix-index.enable = true;

  # Fonts
  fonts.packages = with pkgs;
    [
      # recursive
      emacs-all-the-icons-fonts
      #(nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" "FiraCode" ]; })
      #nerd-fonts.Iosevka
      #nerd-fonts.FiraCode
      #nerd-fonts.JetBrainsMono
    ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  system.keyboard.nonUS.remapTilde = true;
  # hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}]}'

  # emacs daemon
  services.emacsd = {
    package = pkgs.emacs30-nox.override { withNativeCompilation = false; noGui = true; };
    enable = false;
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;
}
