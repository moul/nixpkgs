{ config, lib, pkgs, home, ... }:

with lib;

let cfg = config.services.jankyborders;
in {
  options = with types; {
    services.jankyborders.enable = mkOption {
      type = bool;
      default = false;
      description = "Whether to enable the yabai window manager.";
    };

    services.jankyborders.package = mkOption {
      type = path;
      default = pkgs.jankyborders;
      description = "The jankyborders package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ cfg.package ];
    launchd.user.agents.jankyborders = {
      serviceConfig.ProgramArguments = [ "${cfg.package}/bin/borders" ];
      serviceConfig.KeepAlive = true;
      serviceConfig.RunAtLoad = true;
    };
  };
}
