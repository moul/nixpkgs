{ config, lib, pkgs, ... }:

{
  # Emacs
  programs.emacs.enable = true;

  # General config ----------------------------------------------------------------------------- {{{

  # TODO: emacs-nox
  # TODO: emacs server
  # programs.emacs.package = pkgs.emacsGcc;
}
