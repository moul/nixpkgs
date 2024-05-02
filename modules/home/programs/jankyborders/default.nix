{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.jankyborders;
  home = config.xdg.configHome;
in {
  options.programs.jankyborders = {
    enable = mkEnableOption "jankyborders - lightweight border for macos";

    package = mkOption {
      type = types.path;
      default = pkgs.jankyborders;
      description = "The jankyborders package to use.";
    };

    config = mkOption {
      type = with types; attrsOf str;
      default = {
        style = "round";
        width = "6.0";
        hidpi = "off";
        active_color = "0xffe2e2e3";
        inactive_color = "0xff414550";
      };
      description = ''
        Key/Value pairs to pass to jankyborders's 'config' domain, via the configuration file.
      '';
    };
  };

  config = let
    options =
      concatMapStringsSep " " (optName: "${optName}=${cfg.config.${optName}}")
      (attrNames cfg.config);

    bordersrc = pkgs.writeShellScriptBin "bordersrc" ''
      ${cfg.package}/bin/borders "${options}"        
    '';

  in mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    home.packages = [ pkgs.jankyborders ];
    home.file.".config/borders/bordersrc" = {
      source = "${bordersrc}/bin/bordersrc";
    };
  };
}
