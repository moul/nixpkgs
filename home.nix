{ config, pkgs, lib, ... }:

let
  configd = "~/.config/nixpkgs/config";
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  home = {
    packages = with pkgs; [
      ascii
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      aspellDicts.fr
      bat
      cowsay
      curl
      docker
      docker-buildx
      docker-compose
      ffmpeg
      file
      fortune
      git
      gnumake
      gnupg
      graphviz
      htop
      hub
      imagemagick
      ipfs
      jq
      kitty
      lshw
      lsof
      mosh
      nix-index
      nix-prefetch-scripts
      nmap
      nodejs
      openssl
      pstree
      screen
      tcpdump
      telnet
      tmux
      tree
      unzip
      wget
      #whois
      xorg.xeyes
      youtube-dl
    ];
    #username = "moul";
    #homeDirectory = "/home/moul";

    #file = {
    #  ".spacemacs" = { source = spacemacs; };
    #};

    activation = {
      afterWriteBoundary = config.lib.dag.entryAfter [ "writeBoundary"] ''
        ln -sf ${configd}/.spacemacs ~/.spacemacs
      '';
    };

    sessionVariables = {
      EDITOR = "emacs";
    };
  };

  programs = {
    bash = {
      enable = true;
    };

    emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.nix-mode
        epkgs.magit
      ];
    };

    git = {
      enable = true;
      userName = "Manfred Touron";
      userEmail = "94029+moul@users.noreply.github.com";
      #signing = {
      #  key = "";
      #  signByDefault = true;
      #};
      extraConfig = {
        pull.rebase = true;
      };
    };

    go = {
      enable = true;
    };

    home-manager = {
      enable = true;
      path = "…";
    };

    tmux = {
      enable = true;
      extraConfig = '' # custom
        bind-key r source-file ~/.tmux.conf \; display-message "~/.tmux.conf reloaded"
        
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
        
        set -g status-left ""
        set -g status-left-length 100
        set -g status-right-length 100
        set -g status-right '#[fg=colour235,bg=colour235,nobold,nounderscore,noitalics]#[fg=colour121,bg=colour235] %l:%M %p  %d %b %Y  #[fg=colour238,bg=colour235,nobold,nounderscore,noitalics]#[fg=colour222,bg=colour238] #H #[fg=colour154,bg=colour238,nobold,nounderscore,noitalics]#[fg=colour232,bg=colour154] #(rainbarf --battery --remaining --no-rgb) '
        
        # messages
        set -g message-style 'fg=colour232 bg=colour6 bold'
        
        # Enable mouse control (clickable windows, panes, resizable panes)
        set -g mouse off
        
        # don't rename windows automatically
        set-option -g allow-rename off
      '';
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      history = {
        extended = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git-extras"
          "git"
          "gitfast"
          "github"
        ];
        theme = "agnoster";
        #theme = "frozencow";
      };
      loginExtra = ''
        setopt extendedglob
        source $HOME/.aliases
        bindkey '^R' history-incremental-pattern-search-backward
        bindkey '^F' history-incremental-pattern-search-forward
      '';
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
  };

  #virtualisation = {
  #  docker = {
  #    enable = true;
  #  };
  #};
}
