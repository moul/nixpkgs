{ config, lib, pkgs, ... }:

let
  theme = config.colors.catppuccin-macchiato;
  yabai = "${pkgs.yabai}/bin/yabai";
in {
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # open terminal
      cmd - return [
          * : ${pkgs.kitty}/bin/kitty --single-instance -d ~
          "kitty" ~
      ]

      # open new arc window
      # cmd + <-
      cmd + shift - return : osascript -e 'tell application "Arc" to make new window' -e 'tell application "Arc" to activate'

      ## Window command

      # focus
      lcmd - left : ${yabai} -m window --focus west || yabai -m display --focus west
      lcmd - down : ${yabai} -m window --focus south || yabai -m display --focus south
      lcmd - up : ${yabai} -m window --focus north || yabai -m display --focus north
      lcmd - right : ${yabai} -m window --focus east || yabai -m display --focus east

      # swap
      # lcmd + shift - left : ${yabai} -m window --swap west
      # lcmd + shift - down : ${yabai} -m window --swap south
      # lcmd + shift - up : ${yabai} -m window --swap north
      # lcmd + shift - right : ${yabai} -m window --swap east

      # warp
      lcmd + shift - left : ${yabai} -m window --warp west || ${yabai} -m window --toggle split
      lcmd + shift - down : ${yabai} -m window --warp south || ${yabai} -m window --toggle split
      lcmd + shift - up : ${yabai} -m window --warp north || ${yabai} -m window --toggle split
      lcmd + shift - right : ${yabai} -m window --warp east || ${yabai} -m window --toggle split

      # fullscreen
      lcmd + shift - f : ${yabai} -m window --toggle native-fullscreen

      # equalize window
      lcmd + shift - e : ${yabai} -m space --balance

      # mirror x and y
      lcmd + shift - x: ${yabai} -m space --mirror x-axis
      lcmd + shift - y: ${yabai} -m space --mirror y-axis

      # toggle bsp
      lcmd + shift - b : ${yabai} -m window --toggle float || ${yabai} -m window --toggle bsp

      # toggle split
      lcmd + shift - s : ${yabai} -m window --toggle split

      # emacs client
      # @TODO: use nix abs path
      # @TODO: use current term directory
      cmd + shift - o : emacsclient --create-frame
    '';
  };
}
