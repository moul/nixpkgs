{ config, lib, pkgs, ... }:

let
  theme = config.colors.catppuccin-macchiato;
  yabai = "${pkgs.yabai}/bin/yabai";
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

      ## Window command

      # focus
      alt - left  : ${yabai} -m window --focus west  || yabai -m display --focus west
      alt - down  : ${yabai} -m window --focus south || yabai -m display --focus south
      alt - up    : ${yabai} -m window --focus north || yabai -m display --focus north
      alt - right : ${yabai} -m window --focus east  || yabai -m display --focus east
      alt - j     : ${yabai} -m window --focus west  || yabai -m display --focus west
      alt - n     : ${yabai} -m window --focus south || yabai -m display --focus south
      alt - p     : ${yabai} -m window --focus north || yabai -m display --focus north
      alt - k     : ${yabai} -m window --focus east  || yabai -m display --focus east

      # swap
      alt + shift - left : ${yabai} -m window --swap west  || (${yabai} -m window --display west && yabai -m display --focus west)   || ${yabai} -m window --toggle split
      alt + shift - right : ${yabai} -m window --swap east || (${yabai} -m window --display east && yabai -m display --focus east)   || ${yabai} -m window --toggle split
      alt + shift - up : ${yabai} -m window --swap north   || (${yabai} -m window --display north && yabai -m display --focus north) || ${yabai} -m window --toggle split
      alt + shift - down : ${yabai} -m window --swap south || (${yabai} -m window --display south && yabai -m display --focus south) || ${yabai} -m window --toggle split

      # split
      #lcmd + shift - d : ${yabai} -m window --toggle split

      # increase window size
      #ctrl + lcmd + shift - left  : yabai -m window --resize left:-40:0
      #ctrl + lcmd + shift - down  : yabai -m window --resize bottom:0:40
      #ctrl + lcmd + shift - up    : yabai -m window --resize top:0:-40
      #ctrl + lcmd + shift - right : yabai -m window --resize right:40:0

      # decrease window size
      #ctrl + alt + shift - left  : yabai -m window --resize left:40:0
      #ctrl + alt + shift - down  : yabai -m window --resize bottom:0:-40
      #ctrl + alt + shift - up    : yabai -m window --resize top:0:40
      #ctrl + alt + shift - right : yabai -m window --resize right:-40:0

      # warp
      # alt + shift - left : ${yabai} -m window --warp west || ${yabai} -m window --toggle split
      # alt + shift - down : ${yabai} -m window --warp south || ${yabai} -m window --toggle split
      # alt + shift - up : ${yabai} -m window --warp north || ${yabai} -m window --toggle split
      # alt + shift - right : ${yabai} -m window --warp east || ${yabai} -m window --toggle split

      # fullscreen
      #alt - f : ${yabai} -m window --focus mouse && ${yabai} -m window --toggle zoom-fullscreen
      alt - f : ${yabai} -m window --toggle zoom-fullscreen
      ctrl + lcmd - f : ${yabai} -m window --toggle native-fullscreen
      #ctrl + lcmd - p : ${yabai} -m window --focus mouse && ${yabai} -m window --toggle zoom-parent
      #ctrl + lcmd - m : ${yabai} -m window --minimize

      # toggle bsp
      alt - b : ${yabai} -m window --toggle float || ${yabai} -m window --toggle bsp

      # toggle split
      #ctrl + lcmd - s : ${yabai} -m window --toggle split

      # emacs client
      # @TODO: use nix abs path
      # @TODO: use current term directory
      # alt + shift - o : emacsclient --create-frame

      # focus next space, or the first space if we are at the end
      #lcmd + ctrl - z : ${yabai} -m space --focus next || ${yabai} -m space --focus first

      # focus prev space, or the last space if we are at the beginning
      #lcmd + ctrl - c : ${yabai} -m space --focus prev || ${yabai} -m space --focus last

      alt + ctrl - left :  ${skhd} -k "cmd + ctrl + alt - left"
      alt + ctrl - right : ${skhd} -k "cmd + ctrl + alt - right"
      alt + ctrl - 1 : ${skhd} -k "cmd + ctrl + alt - 1"
      alt + ctrl - 2 : ${skhd} -k "cmd + ctrl + alt - 2"
      alt + ctrl - 3 : ${skhd} -k "cmd + ctrl + alt - 3"
      alt + ctrl - 4 : ${skhd} -k "cmd + ctrl + alt - 4"
      alt + ctrl - 5 : ${skhd} -k "cmd + ctrl + alt - 5"
      alt + ctrl - 6 : ${skhd} -k "cmd + ctrl + alt - 6"
      alt + ctrl - 7 : ${skhd} -k "cmd + ctrl + alt - 7"

      shift + alt + ctrl - left : ${yabai} -m window --space prev; ${skhd} -k "cmd + ctrl + alt - left"
      shift + alt + ctrl - right : ${yabai} -m window --space next; ${skhd} -k "cmd + ctrl + alt - right"
      shift + alt + ctrl - 1 : ${yabai} -m window --space 1; ${skhd} -k "cmd + ctrl + alt - 1"
      shift + alt + ctrl - 2 : ${yabai} -m window --space 2; ${skhd} -k "cmd + ctrl + alt - 2"
      shift + alt + ctrl - 3 : ${yabai} -m window --space 3; ${skhd} -k "cmd + ctrl + alt - 3"
      shift + alt + ctrl - 4 : ${yabai} -m window --space 4; ${skhd} -k "cmd + ctrl + alt - 4"
      shift + alt + ctrl - 5 : ${yabai} -m window --space 5; ${skhd} -k "cmd + ctrl + alt - 5"
      shift + alt + ctrl - 6 : ${yabai} -m window --space 6; ${skhd} -k "cmd + ctrl + alt - 6"
      shift + alt + ctrl - 7 : ${yabai} -m window --space 7; ${skhd} -k "cmd + ctrl + alt - 7"
    '';
  };
}
