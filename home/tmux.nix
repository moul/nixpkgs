{ config, lib, pkgs, ... }:

{
  # Tmux
  # https://tmuxguide.readthedocs.io/en/latest/tmux/tmux.html
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fzf.tmux.enableShellIntegration
  programs.tmux.enable = true;

  # General config ----------------------------------------------------------------------------- {{{

programs.tmux.terminal = "screen-256color";
  programs.tmux.keyMode = "emacs";
}
