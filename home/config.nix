{ lib, pkgs, config, ... }:

let
  inherit (pkgs) stdenv;
  inherit (lib) mkIf;
in {
  # btop
  home.file."/.config/btop" = {
    source = "${lib.cleanSource ../config/btop}";
    recursive = true;
  };

  # npmrc
  home.file.".npmrc" = with pkgs; {
    source = writeText "npmrc" ''
      prefix=${config.xdg.dataHome}/node_modules
    '';
  };

  # sketchybar
  # home.file."/.config/sketchybar" = {
  #   source = "${lib.cleanSource ../config/sketchybar}";
  #   recursive = true;
  # };

  # yabai
  # home.file."/.config/yabai" = {
  #   source = "${lib.cleanSource ../config/yabai}";
  #   recursive = true;
  # };

  # home.file."/.config/skhd" = {
  #   source = "${lib.cleanSource ../config/skhd}";
  #   recursive = true;
  # };

  # link aspell config
  home.file.".aspell.config" = with pkgs; {
    source = writeText "aspell.conf" ''
      dict-dir ""
      master en_US
      extra-dicts en en-computers.rws en-science.rws fr.rws
    '';
  };

}
