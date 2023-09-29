{ config, lib, pkgs, ... }:

let
  theme = config.colors.catppuccin-macchiato;
  yellow = theme.namedColors.yellow;
  black = theme.namedColors.black;
  yabai = "${pkgs.yabai}/bin/yabai";
  hexYellow = builtins.substring 1 (builtins.stringLength yellow) yellow;
  hexBlack = builtins.substring 1 (builtins.stringLength black) black;
  yabai_border = pkgs.writeShellScriptBin "hook" ''
    #!/bin/bash

    is_fullscreen=$(${yabai} -m query --windows --window "$YABAI_WINDOW_ID" | jq -re '.["zoom-fullscreen"]')
    has_border=$(${yabai} -m query --windows --window "$YABAI_WINDOW_ID" | jq -re '.["border"]')

    if [[ "$is_fullscreen" -eq "1" ]]; then
      if [[ "$has_border" -eq "1" ]]; then
        ${yabai} -m window "$YABAI_WINDOW_ID" --toggle border
      fi
    else
      if [[ "$has_border" -eq "0" ]]; then
        ${yabai} -m window "$YABAI_WINDOW_ID" --toggle border
      fi
    fi
  '';
in {
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    #configFile =
    #  "/Users/${config.users.primaryUser.username}/.config/yabai/yabairc";
    config = {
      active_window_border_color = "0xff888888";
      active_window_opacity = "1.000000";
      active_window_border_topmost = "off";
      auto_balance = "off";
      external_bar = "all:0:0";
      focus_follows_mouse = "autoraise";
      layout = "bsp";
      mouse_action1 = "resize";
      mouse_action2 = "move";
      mouse_drop_action = "swap";
      mouse_follows_focus = "off";
      mouse_modifier = "fn";
      normal_window_border_color = "0xff444444";
      insert_feedback_color = "0xffff0000";
      normal_window_opacity = "1";
      split_ratio = "0.500000";
      split_type = "auto";
      right_padding = "3";
      bottom_padding = "3";
      left_padding = "3";
      top_padding = "3";
      window_animation_duration = "0";
      window_opacity_duration = "0";

      window_border = "on";
      window_border_blur = "off";
      window_border_radius = "0";
      window_border_width = "4";
      window_border_placement = "inset";

      window_gap = "5";
      window_opacity = "off";
      window_placement = "second_child";
      window_shadow = "off";
      window_topmost = "on";
    };

    extraConfig = ''
      # You might need to manually source this or integrate in a different way
      # yabai -m space --balance

      for _ in $(yabai -m query --spaces | jq '.[].index | select(. > 6)'); do
          yabai -m space --destroy 7
      done

      function setup_space {
        local idx="$1"
        local name="$2"
        local space=
        echo "setup space $idx : $name"

        space=$(yabai -m query --spaces --space "$idx")
        if [ -z "$space" ]; then
          yabai -m space --create
        fi
        yabai -m space "$idx" --label "$name"
      }

      setup_space 1 main
      setup_space 2 web
      setup_space 3 code
      setup_space 4 social
      setup_space 5 media
      setup_space 6 other

      yabai -m rule -add app="^Arc$" space=2
      yabai -m rule -add app="^Safari$" space=2
      yabai -m rule -add app="^Firefox$" space=2
      yabai -m rule -add app="^Kitty$" space=3
      yabai -m rule -add app="^Texts$" space=4
      yabai -m rule -add app="^Telegram$" space=4
      yabai -m rule -add app="^Messages$" space=4
      yabai -m rule -add app="^Signal$" space=4
      yabai -m rule -add app="^Slack$" space=4
      yabai -m rule --add app="^Music$" space=5
      yabai -m rule --add app="^Spotify$" space=5

      yabai -m rule --add app="^(Terminal|Calculator|Software Update|Dictionary|VLC|System Preferences|System Settings|zoom.us|Photo Booth|Archive Utility)$" manage=off
      yabai -m rule --add app="^(Python|LibreOffice|App Store|Steam|Alfred|Activity Monitor|NVIDIA GeForce Now)$" manage=off
      yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
      yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
      yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
      yabai -m rule --add label="ArcUnstadard" app="^Arc$" subrole!="AXStandardWindow" border=off manage=off
      yabai -m rule --add label="iStat" app="^iStat*" sticky=on layer=above manage=off border=off
      yabai -m rule --add app="1Password" manage=off sticky=on border=off
      yabai -m rule --add app="QuickGPT" manage=off sticky=on border=off
      yabai -m rule --add app="^(emacs|Xcode)$" manage=on border=on
      #yabai -m rule --add app="^Reminders$" manage=off sticky=on border=off
      yabai -m rule --add app="^Reminders$" title="META SCREEN" manage=on border=on

      #yabai -m signal --add event=space_changed action="osascript -e 'tell application \"Übersicht\" to refresh widget id \"simple-bar-index-jsx\"'"
      yabai -m signal --add even=space_changed action="osascript -e tell application \"Übersicht\" to refresh"

      yabai -m signal --add event=window_resized action="${yabai_border}/bin/hook"

    '';
  };
}
