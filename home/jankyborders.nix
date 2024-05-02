{ config, lib, pkgs, ... }:

let
  theme = config.colors.catppuccin-macchiato;
  yellow = theme.namedColors.yellow;
  black = theme.namedColors.black;
  hexYellow = builtins.substring 1 (builtins.stringLength yellow) yellow;
  hexBlack = builtins.substring 1 (builtins.stringLength black) black;
in {
  # XXX: move this to darwin 
  programs.jankyborders = {
    enable = true;
    config = {
      style = "round";
      width = "8.0";
      hidpi = "off";
      active_color = "0xff${hexYellow}";
      inactive_color = "0xff${hexBlack}";
    };
  };
}
