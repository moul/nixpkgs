{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh.oh-my-zsh.extras;
  pluginExtra = types.submodule ({ config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = "";
        description = "name of the plugin";
      };
      source = mkOption {
        type = types.path;
        default = "";
        description = "target plugin path";
      };
      config = mkOption {
        type = types.str;
        default = "";
        description = "plugin config";
      };
    };
  });

  themeExtra = types.submodule ({ config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = "";
        description = "name of the extra theme";
      };

      source = mkOption {
        type = types.path;
        default = "";
        description = "target path";
      };
    };
  });

in {
  options.programs.zsh.oh-my-zsh.extras = {
    plugins = mkOption {
      type = types.listOf pluginExtra;
      default = [ ];
      description = "list of extra plugins";
    };
    themes = mkOption {
      type = types.listOf themeExtra;
      default = [ ];
      description = "list of extra themes";
    };
  };

  config = let
    pluginsName =
      (map (plugin: "${plugin.name}") config.programs.zsh.oh-my-zsh.plugins);
    pluginsList = (map (plugin: {
      name = "${config.programs.zsh.oh-my-zsh.custom}/plugins/${plugin.name}";
      value = {
        source = plugin.source;
        recursive = true;
      };
    }) cfg.plugins);

    themesList = (map (theme: {
      name = "${config.programs.zsh.oh-my-zsh.custom}/themes/${theme.name}";
      value = {
        source = theme.source;
        recursive = true;
      };
    }) cfg.themes);

    configExtra = lib.concatStringsSep "\n" (map (plugin: ''
      ## ${plugin.name} config

      ${plugin.config}
    '') (filter (plugin: plugin.config != "") cfg.plugins));

  in mkIf config.programs.zsh.oh-my-zsh.enable {
    home.file = listToAttrs (pluginsList ++ themesList);
    programs.zsh.initExtra = mkIf (configExtra != "") ''
      # oh-my-zsh plugins config

      ${configExtra}      
    '';
  };
}
