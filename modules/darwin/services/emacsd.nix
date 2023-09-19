{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.emacsd;
in {
  options = {
    services.emacsd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the Emacs Daemon.";
      };

      package = mkOption {
        type = types.path;
        default = pkgs.emacs;
        description = "This option specifies the emacs package to use.";
      };

      additionalPath = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "/Users/my_user_name" ];
        description = ''
          This option specifies additional PATH that the emacs daemon would have.
          Typically if you have binaries in your home directory that is what you would add your home path here.
          One caveat is that there won't be shell variable expansion, so you can't use $HOME for example
        '';
      };

      exec = mkOption {
        type = types.str;
        default = "emacs";
        description = "Emacs command/binary to execute.";
      };

      term = mkOption {
        type = types.str;
        default = "xterm";
        description = "terminfo to execute with emacs";
      };
    };
  };

  config = let
    emacsd = pkgs.writeShellScriptBin "emacsd" ''
      export TERMINFO_DIRS="${config.system.path}/share/terminfo";
      export TERM=xterm-emacs
      ${cfg.package}/bin/${cfg.exec} --with-profile=spacemacs --fg-daemon
    '';
  in mkIf cfg.enable {
    launchd.user.agents.emacsd = {
      path = cfg.additionalPath ++ [ config.environment.systemPath ];
      serviceConfig = {
        ProgramArguments = [ "${pkgs.zsh}/bin/zsh" "${emacsd}/bin/emacsd" ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardErrorPath = "/tmp/emacsd.log";
        StandardOutPath = "/tmp/emacsd.log";
      };
    };
  };
}
