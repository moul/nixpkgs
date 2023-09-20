{ config, lib, pkgs, ... }:

let
  theme = config.colors.catppuccin-macchiato;
  yabai = "${pkgs.yabai}/bin/yabai";
in {
  services.skhd = {
    enable = true;
    skhdConfig = ''
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
      alt - left : ${yabai} -m window --focus west || yabai -m display --focus west
      alt - down : ${yabai} -m window --focus south || yabai -m display --focus south
      alt - up : ${yabai} -m window --focus north || yabai -m display --focus north
      alt - right : ${yabai} -m window --focus east || yabai -m display --focus east

      # swap
      ## left
      alt + shift - left : ${yabai} -m window --swap west \
           || (${yabai} -m window --display west && yabai -m display --focus west) \
           || ${yabai} -m window --toggle split
      alt + shift - k : ${yabai} -m window --swap west \
           || (${yabai} -m window --display west && yabai -m display --focus west) \
           || ${yabai} -m window --toggle split
      ## right
      alt + shift - right : ${yabai} -m window --swap east \
           || (${yabai} -m window --display east && yabai -m display --focus east) \
           || ${yabai} -m window --toggle split
      #alt + shift - ';' : ${yabai} -m window --swap east \
      #     || (${yabai} -m window --display east && yabai -m display --focus east) \
      #     || ${yabai} -m window --toggle split
      ## up
      alt + shift - up : ${yabai} -m window --swap north \
           || (${yabai} -m window --display north && yabai -m display --focus north) \
           || ${yabai} -m window --toggle split
      alt + shift - k : ${yabai} -m window --swap north \
           || (${yabai} -m window --display north && yabai -m display --focus north) \
           || ${yabai} -m window --toggle split
      ## down
      alt + shift - down : ${yabai} -m window --swap south \
           || (${yabai} -m window --display south && yabai -m display --focus south) \
           || ${yabai} -m window --toggle split
      alt + shift - j : ${yabai} -m window --swap south \
           || (${yabai} -m window --display south && yabai -m display --focus south) \
           || ${yabai} -m window --toggle split

      # split
      alt + shift - d : ${yabai} -m window --toggle split

      # increase window size
      ctrl + alt - h : yabai -m window --resize left:-40:0
      ctrl + alt - j : yabai -m window --resize bottom:0:40
      ctrl + alt - k : yabai -m window --resize top:0:-40
      ctrl + alt - l : yabai -m window --resize right:40:0

      # decrease window size
      ctrl + alt + alt - h : yabai -m window --resize left:40:0
      ctrl + alt + alt - j : yabai -m window --resize bottom:0:-40
      ctrl + alt + alt - k : yabai -m window --resize top:0:40
      ctrl + alt + alt - l : yabai -m window --resize right:-40:0


      # warp
      # alt + shift - left : ${yabai} -m window --warp west || ${yabai} -m window --toggle split
      # alt + shift - down : ${yabai} -m window --warp south || ${yabai} -m window --toggle split
      # alt + shift - up : ${yabai} -m window --warp north || ${yabai} -m window --toggle split
      # alt + shift - right : ${yabai} -m window --warp east || ${yabai} -m window --toggle split

      # fullscreen
      alt + shift - f : ${yabai} -m window --toggle native-fullscreen
      alt - f : ${yabai} -m window --focus mouse && \
                ${yabai} -m window --toggle zoom-fullscreen
      alt - p : ${yabai} -m window --focus mouse && \
              ${yabai} -m window --toggle zoom-parent


      # equalize window
      alt + shift - e : ${yabai} -m space --balance

      # mirror x and y
      alt + shift - x: ${yabai} -m space --mirror x-axis
      alt + shift - y: ${yabai} -m space --mirror y-axis

      # toggle bsp
      alt + shift - b : ${yabai} -m window --toggle float || ${yabai} -m window --toggle bsp

      # toggle split
      alt + shift - s : ${yabai} -m window --toggle split

      # emacs client
      # @TODO: use nix abs path
      # @TODO: use current term directory
      # alt + shift - o : emacsclient --create-frame
    '';
  };
}
