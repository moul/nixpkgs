{ config, lib, pkgs, ... }:

let
  inherit (config.home.user-info) nixConfigDirectory;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  #configsd = mkOutOfStoreSymlink "${nixConfigDirectory}/configs";
  configsd = "~/go/src/moul.io/nixpkgs/configs";
in {
  # Emacs
  programs.emacs.enable = true;

  # General config ----------------------------------------------------------------------------- {{{

  # TODO: emacs-nox
  # TODO: emacs server
  programs.emacs.package = pkgs.emacsNativeComp;

  # Spacemacs
  home.file.".emacs.d" = {
    source = pkgs.spacemacs;
    #resursive = true;
  };

  home.activation.customEndHook = config.lib.dag.entryAfter ["reloadSystemd" "writeBoundary" "onFilesChange" "installPackages"] ''
    ln -sf ${configsd}/.spacemacs ~/.spacemacs;

    # setup .emacs cache dir (TODO: find a nix idiomatic way).
    for dir in .cache elpa; do
      mkdir -p ${config.xdg.cacheHome}/emacs/$dir;
      sudo mv ~/.emacs.d/$dir ~/.emacs.d/$dir.old;
      sudo ln -s ${config.xdg.cacheHome}/emacs/$dir/ ~/.emacs.d/$dir;
    done
  '';
}

# TODO: centralize here: "em", and "emacs-nox"
