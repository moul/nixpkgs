{ config, lib, pkgs, ... }:

{
  # Tmux
  # https://tmuxguide.readthedocs.io/en/latest/tmux/tmux.html
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fzf.tmux.enableShellIntegration
  programs.tmux.enable = true;

  # General config ----------------------------------------------------------------------------- {{{

  programs.tmux.terminal = "screen-256color";
  programs.tmux.keyMode = "emacs";
  programs.tmux.shell = "${pkgs.zsh}/bin/zsh";
  #programs.tmux.shell = "${pkgs.fish}/bin/fish";
  programs.tmux.escapeTime = 20;
  programs.tmux.clock24 = true;
  programs.tmux.baseIndex = 1;
  programs.tmux.plugins = with pkgs; [
    tmuxPlugins.copycat
    tmuxPlugins.resurrect
    tmuxPlugins.sensible
    tmuxPlugins.prefix-highlight
    # tmuxPlugins.tmux-update-display # not yet available on nix, but can be loaded with tpm
    tmuxPlugins.yank
    {
      plugin = tmuxPlugins.continuum;
      extraConfig = ''
        set -g @continuum-restore 'on'
        set -g @continuum-save-interval '60' # minutes
      '';
    }
  ];
  programs.tmux.extraConfig = ''
    # custom
    bind-key -n C-S-Left swap-window -t -1
    bind-key -n C-S-Right swap-window -t +1
    # loud or quiet?
    set -g visual-activity off
    set -g visual-bell off
    set -g visual-silence off
    setw -g monitor-activity off
    set -g bell-action none
    #  modes
    setw -g clock-mode-colour colour5
    setw -g mode-style 'fg=colour1 bg=colour18 bold'
    # panes
    set -g pane-border-style 'fg=colour9 bg=colour0'
    set -g pane-active-border-style 'bg=colour5 fg=colour9'
    set -g display-panes-time 3000
    # statusbar
    set -g status-position bottom
    set -g status-justify left
    set -g status-style 'bg=colour16 fg=colour137 dim'
    set -g status-interval 5               # set update frequencey (default 15 seconds)
    setw -g window-status-current-style 'fg=colour1 bg=colour21 bold'
    setw -g window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '
    setw -g window-status-style 'fg=colour9 bg=colour18'
    setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
    setw -g window-status-bell-style 'fg=colour255 bg=colour1 bold'
    set -g status-left " #[fg=colour9]#S "
    set -g status-left-length 100
    set -g status-right-length 100
    set -g status-right '#{prefix_highlight} #[fg=colour1,bg=colour18,nobold,nounderscore,noitalics]#[fg=colour121,bg=colour18] %l:%M %p  %d %b %Y  #[fg=colour1,bg=colour18,nobold,nounderscore,noitalics]#[fg=colour1,bg=colour21,bold] #H #[fg=colour1,bg=colour21,nobold,nounderscore,noitalics]#[fg=colour21,bg=colour1]  #(rainbarf --battery --remaining --no-rgb) '
    # messages
    set -g message-style 'fg=colour232 bg=colour6 bold'
    # Enable mouse control (clickable windows, panes, resizable panes)
    set -g mouse off
    # don't rename windows automatically
    set-option -g allow-rename off
  '';

  # reload, with:
  #   source-file ~/.config/tmux/tmux.conf

}
