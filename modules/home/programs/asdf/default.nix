{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.myasdf;
  toolModule = types.submodule ({ config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        description = "The name of the tool.";
      };

      version = mkOption {
        type = types.str;
        default = "";
        description = "tool version.";
      };

      inputs = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = "list of build inputs";
      };

      preInstall = mkOption {
        type = types.str;
        default = "";
        description = "pre install command";
      };

      postInstall = mkOption {
        type = types.str;
        default = "";
        description = "post install command";
      };
    };
  });
in {
  options.programs.myasdf = {
    enable = mkEnableOption "asdf tools manager";

    package = mkOption {
      type = types.package;
      default = pkgs.asdf-vm;
      defaultText = literalExample "pkgs.asdf-vm";
      example = literalExample "pkgs.asdf-vm";
      description = "The asdf package to use.";
    };

    asdfdir = mkOption {
      type = types.str;
      default = "${config.xdg.dataHome}/asdf";
    };
  };

  config = let
    asdf-config = pkgs.writeText "asdfrc" ''
      # See the docs for explanations: https://asdf-vm.com/manage/configuration.html

      legacy_version_file = no
      use_release_candidates = no
      always_keep_download = no
      disable_plugin_short_name_repository = no
      ${if pkgs.stdenv.isDarwin then
        "java_macos_integration_enable = yes"
      else
        ""}
    '';

  in mkIf config.programs.myasdf.enable {
    home.packages = [ cfg.package ];
    home.file."${config.xdg.configHome}/asdf/asdfrc" = {
      source = asdf-config;
    };

    # # asdf env variables
    home.sessionVariables = {
      ASDF_CONFIG_FILE = "${config.xdg.configHome}/asdf/asdfrc";
      ASDF_DATA_DIR = "${cfg.asdfdir}";
      ASDF_DIR = "${cfg.package}/share/asdf-vm";
    };

    programs.zsh.initExtra = ''
      if [ -f "${cfg.package}/share/asdf-vm/asdf.sh" ]; then
        . "${cfg.package}/share/asdf-vm/asdf.sh"
      fi

      fpath=(${cfg.package}/share/asdf-vm/completions $fpath)
    '';
  };
}
