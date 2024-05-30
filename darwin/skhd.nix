{ config, lib, pkgs, ... }:

let
  theme = config.colors.catppuccin-macchiato;
  skhd = "${pkgs.skhd}/bin/skhd";
in {
  services.skhd = {
    enable = true;
    skhdConfig = ''
      #alt + shift - k [
      #    * : ${pkgs.kitty}/bin/kitty --single-instance -d ~
      #    "kitty" ~
      #]
      #alt + shift - a : osascript -e 'tell application "Arc" to make new window' -e 'tell application "Arc" to activate'
      #alt + shift - r : open -n -a "Reminders"
      #alt + shift - t : open -n -a "Texts"
      #alt + shift - p : open -n -a "1Password"

      # emacs client
      # @TODO: use nix abs path
      # @TODO: use current term directory
      # alt + shift - o : emacsclient --create-frame

      #alt + ctrl - left :  ${skhd} -k "cmd + ctrl + alt - left"
      #alt + ctrl - right : ${skhd} -k "cmd + ctrl + alt - right"
      #alt + ctrl - 1 : ${skhd} -k "cmd + ctrl + alt - 1"
      #alt + ctrl - 2 : ${skhd} -k "cmd + ctrl + alt - 2"
      #alt + ctrl - 3 : ${skhd} -k "cmd + ctrl + alt - 3"
      #alt + ctrl - 4 : ${skhd} -k "cmd + ctrl + alt - 4"
      #alt + ctrl - 5 : ${skhd} -k "cmd + ctrl + alt - 5"
      #alt + ctrl - 6 : ${skhd} -k "cmd + ctrl + alt - 6"
      #alt + ctrl - 7 : ${skhd} -k "cmd + ctrl + alt - 7"
    '';
  };
}
