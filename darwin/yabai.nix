{ config, lib, pkgs, ... }:

let
  theme = config.colors.catppuccin-macchiato;
  yellow = theme.namedColors.yellow;
  black = theme.namedColors.black;
  hexYellow = builtins.substring 1 (builtins.stringLength yellow) yellow;
  hexBlack = builtins.substring 1 (builtins.stringLength black) black;
in {
  services.yabai = {
    enable = true;
    enableScriptingAddition = false;
    config = {
      layout = "bsp";
      active_window_border_color = "0xff${hexYellow}";
      auto_balance = "on";
      external_bar = "all:0:0";
      focus_follows_mouse = "off";
      mouse_modifier = "fn";
      mouse_action1 = "resize";
      mouse_action2 = "move";
      mouse_drop_action = "swap";
      mouse_follows_focus = "off";
      normal_window_border_color = "0x11${hexBlack}";
      window_animation_duration = 0.15;
      window_border = "on";
      window_border_radius = 11;
      window_border_width = 4;
      window_gap = 8;
      window_placement = "second_child";
      window_shadow = "float";
      window_topmost = "off";
      split_ratio = 0.5;
      top_padding = 5;
      bottom_padding = 5;
      left_padding = 5;
      right_padding = 5;
    };

    extraConfig = ''
      # You might need to manually source this or integrate in a different way
      yabai -m space --balance

      yabai -m rule --add app="^(Terminal|Calculator|Software Update|Dictionary|VLC|System Preferences|System Settings|zoom.us|Photo Booth|Archive Utility)$" manage=off
      yabai -m rule --add app="^(Python|LibreOffice|App Store|Steam|Alfred|Activity Monitor|NVIDIA GeForce Now)$" manage=off
      yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
      yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
      yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
      yabai -m rule --add label="ArcUnstadard" app="^Arc$" subrole!="AXStandardWindow" border=off manage=off
      yabai -m rule --add label="iStat" app="^iStat*" sticky=on layer=above manage=off border=off

      yabai -m rule --add app="^(emacs|Xcode)$" manage=on
    '';
  };
}
