{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.zsh.zi;

  pluginModule = types.submodule ({ config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        description = "The name of the plugin.";
      };

      tags = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "The plugin tags.";
      };
    };
  });

in {
  options.programs.zsh.zi = {
    enable = mkEnableOption "zi - a zsh plugin manager";

    home = mkOption {
      type = types.path;
      default = "${config.home.homeDirectory}/.zi";
      defaultText = "~/.zi";
      apply = toString;
      description = "Path to zi home directory.";
    };

    bin = mkOption {
      type = types.path;
      default = "${config.home.homeDirectory}/.zi/bin";
      defaultText = "~/.zi/bin";
      apply = toString;
      description = "Path to zi bin directory.";
    };

    plugins = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = "List of zi plugins.";
    };

    debug = mkOption {
      type = types.bool;
      default = false;
      description = "use load instead of light";
    };

    config = mkOption {
      type = types.str;
      default = "";
      description = "zi config";
    };
  };

  config = let
    # zi-setup = pkgs.writeText  "zi-setup.zsh" ''
    #     typeset -A ZI
    #     HOME_DIR=$out/share/zi
    #     mkdir -p $HOME_DIR
    #     ZI[HOME_DIR]="$HOME_DIR"
    #     ZI[BIN_DIR]="${cfg.bin}"
    #     source "''${ZI[BIN_DIR]}/zi.zsh"
    # '';
    # zi-gen = pkgs.runCommandLocal "zi-gen" {
    #   buildInputs = [ pkgs.libiconv pkgs.gitAndTools.git ];
    # } "${pkgs.zsh}/bin/zsh ${zi-setup}";

    # load-key = if cfg.debug then "load-mode" else "light-mode" ;
    # zi-plugins-list = lib.concatStringsSep "\\n" cfg.plugins;
  in mkIf cfg.enable {
    home.packages = [ pkgs.zsh ];
    programs.zsh.completionInit =
      "autoload -Uz _zi && (( \${+_comps} )) && _comps[zi]=_zi";
    programs.zsh.initExtraBeforeCompInit = ''
      typeset -A ZI
      ZI[HOME_DIR]="${cfg.home}"
      ZI[BIN_DIR]="${cfg.bin}"
      source "''${ZI[BIN_DIR]}/zi.zsh"

      ${cfg.config}
    '';
  };
}
