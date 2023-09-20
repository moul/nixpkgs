{ config, lib, pkgs, ... }:

let
  theme = config.colors.catppuccin-macchiato;
  yabai = "${pkgs.yabai}/bin/yabai";
in {
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # open terminal
      #cmd - return [
      #    * : ${pkgs.kitty}/bin/kitty --single-instance -d ~
      #    "kitty" ~
      #]

      # open new arc window
      # cmd + <-
      #cmd + shift - return : osascript -e 'tell application "Arc" to make new window' -e 'tell application "Arc" to activate'

      alt + shift - k [
          * : ${pkgs.kitty}/bin/kitty --single-instance -d ~
          "kitty" ~
      ]
      alt + shift - a : osascript -e 'tell application "Arc" to make new window' -e 'tell application "Arc" to activate'
      alt + shift - r : open -n -a "Reminders"
      alt + shift - t : open -n -a "Texts"
      alt + shift - p : open -n -a "1Password"

      ## Window command

      # focus
      lcmd - left : ${yabai} -m window --focus west || yabai -m display --focus west
      lcmd - down : ${yabai} -m window --focus south || yabai -m display --focus south
      lcmd - up : ${yabai} -m window --focus north || yabai -m display --focus north
      lcmd - right : ${yabai} -m window --focus east || yabai -m display --focus east

      # swap
      ## left
      lcmd + shift - left : ${yabai} -m window --swap west \
           || (${yabai} -m window --display west && yabai -m display --focus west) \
           || ${yabai} -m window --toggle split
      lcmd + shift - k : ${yabai} -m window --swap west \
           || (${yabai} -m window --display west && yabai -m display --focus west) \
           || ${yabai} -m window --toggle split
      ## right
      lcmd + shift - right : ${yabai} -m window --swap east \
           || (${yabai} -m window --display east && yabai -m display --focus east) \
           || ${yabai} -m window --toggle split
      #lcmd + shift - ';' : ${yabai} -m window --swap east \
      #     || (${yabai} -m window --display east && yabai -m display --focus east) \
      #     || ${yabai} -m window --toggle split
      ## up
      lcmd + shift - up : ${yabai} -m window --swap north \
           || (${yabai} -m window --display north && yabai -m display --focus north) \
           || ${yabai} -m window --toggle split
      lcmd + shift - k : ${yabai} -m window --swap north \
           || (${yabai} -m window --display north && yabai -m display --focus north) \
           || ${yabai} -m window --toggle split
      ## down
      lcmd + shift - down : ${yabai} -m window --swap south \
           || (${yabai} -m window --display south && yabai -m display --focus south) \
           || ${yabai} -m window --toggle split
      lcmd + shift - j : ${yabai} -m window --swap south \
           || (${yabai} -m window --display south && yabai -m display --focus south) \
           || ${yabai} -m window --toggle split

      # split
      lcmd + shift - d : ${yabai} -m window --toggle split

      # increase window size
      ctrl + alt - h : yabai -m window --resize left:-40:0
      ctrl + alt - j : yabai -m window --resize bottom:0:40
      ctrl + alt - k : yabai -m window --resize top:0:-40
      ctrl + alt - l : yabai -m window --resize right:40:0

      # decrease window size
      ctrl + alt + lcmd - h : yabai -m window --resize left:40:0
      ctrl + alt + lcmd - j : yabai -m window --resize bottom:0:-40
      ctrl + alt + lcmd - k : yabai -m window --resize top:0:40
      ctrl + alt + lcmd - l : yabai -m window --resize right:-40:0


      # warp
      # lcmd + shift - left : ${yabai} -m window --warp west || ${yabai} -m window --toggle split
      # lcmd + shift - down : ${yabai} -m window --warp south || ${yabai} -m window --toggle split
      # lcmd + shift - up : ${yabai} -m window --warp north || ${yabai} -m window --toggle split
      # lcmd + shift - right : ${yabai} -m window --warp east || ${yabai} -m window --toggle split

      # fullscreen
      lcmd + shift - f : ${yabai} -m window --toggle native-fullscreen
      alt - f : ${yabai} -m window --focus mouse && \
                ${yabai} -m window --toggle zoom-fullscreen
      alt - p : ${yabai} -m window --focus mouse && \
              ${yabai} -m window --toggle zoom-parent


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
