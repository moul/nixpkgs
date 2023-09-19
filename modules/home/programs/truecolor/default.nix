{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.truecolor;
in {
  options.programs.truecolor = {
    enable = mkEnableOption "truecolor";
    useterm = mkOption {
      type = types.str;
      default = "xterm-256colors";
      description = ''
        term to use
      '';
    };
    terminfo = mkOption {
      type = types.str;
      default = "/usr/share/terminfo";
      description = ''
        terminfo path to use
      '';
    };
  };

  config = let
    xterm-source = pkgs.writeText "xterm.terminfo" ''
      xterm-emacs|xterm with 24-bit direct color mode for Emacs,
        use=${cfg.useterm},
        setb24=\E[48\:2\:\:%p1%{65536}%/%d\:%p1%{256}%/%{255}%&\
           %d\:%p1%{255}%&%dm,
        setf24=\E[38\:2\:\:%p1%{65536}%/%d\:%p1%{256}%/%{255}%&\
           %d\:%p1%{255}%&%dm,
    '';

    xterm-emacs = pkgs.runCommandLocal "xterm-emacs" {
      output = [ "terminfo" ];
      nativeBuildInputs = [ pkgs.ncurses ];
    } ''
      mkdir -p $out/share/terminfo
      export TERMINFO_DIRS=${cfg.terminfo}
      tic -x -o $out/share/terminfo ${xterm-source}
    '';

  in mkIf config.programs.truecolor.enable {
    home.packages = [ xterm-emacs ];
    home.file.".terminfo".source = "${xterm-emacs}/share/terminfo";
  };
}
