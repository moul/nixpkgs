{ config, lib, pkgs, ... }:

let
  inherit (config.home) user-info homeDirectory;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  #configsd = mkOutOfStoreSymlink "${user-info.nixConfigDirectory}/configs";
  configsd = "~/go/src/moul.io/nixpkgs/configs";
  xterm-emacsclient = pkgs.writeShellScriptBin "xemacsclient" ''
    export TERM=xterm-emacs
    ${pkgs.emacs-gtk}/bin/emacsclient $@
  '';
  xterm-emacs = pkgs.writeShellScriptBin "xemacs" ''
    export TERM=xterm-emacs
    ${pkgs.emacs-gtk}/bin/emacs $@
  '';
in {

  home.file."emacs/spacemacs" = {
    source = pkgs.spacemacs;
    recursive = true;
  };
  home.file.".emacs.d" = {
    source = pkgs.chemacs2;
    recursive = true;
  };

  home.file.".emacs-profile" = with pkgs; {
    source = writeText "emacs-profiles" "spacemacs";
  };
  home.file.".emacs-profiles.el" = with pkgs; {
    source = writeText "emacs-profiles" ''
      (
       ("doom" . ((user-emacs-directory . "~/emacs/doomemacs")
             (env . (("DOOMDIR" . "~/doom-config")))))
       ("spacemacs" . ((user-emacs-directory . "~/emacs/spacemacs")))
      )
    '';
  };

  # spacemacs
  home.file.".spacemacs.d" = {
    source = "${lib.cleanSource ../configs/spacemacs}";
    recursive = true;
  };

  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacs-gtk;

  # setup alias
  programs.zsh.shellAliases.emacs = "${xterm-emacs}/bin/xemacs";
  programs.zsh.shellAliases.emacsclient =
    "${xterm-emacsclient}/bin/xemacsclient";
  programs.zsh.shellAliases.ec = "${xterm-emacsclient}/bin/xemacsclient -nw";

  #  # Emacs
  #  programs.emacs.enable = true;
  #
  #  # home.packages = with pkgs; [ em ];
  #
  #  # General config ----------------------------------------------------------------------------- {{{
  #
  #  # TODO: emacs-nox
  #  # TODO: emacs server
  #  # TODO: 'emacs -nw' by default
  #  programs.emacs.package = pkgs.emacsNativeComp;
  #
  #  # Spacemacs
  #  home.file.".emacs.d" = {
  #    source = pkgs.spacemacs;
  #    recursive = true;
  #  };
  #
  #  home.activation.emacsdPopulate = config.lib.dag.entryAfter [
  #    "reloadSystemd"
  #    "writeBoundary"
  #    "onFilesChange"
  #    "installPackages"
  #  ] ''
  #    ln -sf ${configsd}/.spacemacs ~/.spacemacs;
  #
  #    # setup .emacs cache dir (TODO: find a nix idiomatic way).
  #    #for dir in .cache elpa; do
  #    #  mkdir -p ${config.xdg.cacheHome}/emacs/$dir;
  #    #  sudo mv ~/.emacs.d/$dir ~/.emacs.d/$dir.old || true;
  #    #  sudo ln -s ${config.xdg.cacheHome}/emacs/$dir/ ~/.emacs.d/$dir;
  #    #done
  #  '';
}
