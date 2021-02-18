# https://rycee.gitlab.io/home-manager/options.html

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
      assh
      bat
      coreutils
      cowsay
      curl
      diff-so-fancy
      docker
      docker-buildx
      docker-compose
      du-dust
      emacs-nox
      exa
      fd
      ffmpeg
      file
      fortune
      fzf
      gh
      git
      gnumake
      gnupg
      (buildEnv {
        name = "golang";
        paths = with super; [
          go
          gopls
          golangci-lint
          go2nix
          gocode
          gofumpt
          # exclude bundle
          (gotools.overrideDerivation (oldAttrs: {
            excludedPackages = oldAttrs.excludedPackages + "\\|\\(bundle\\)";
          }))
        ];
      })
      graphviz
      htop
      hub
      imagemagick
      ipfs
      ispell
      jq
      kitty
      lshw
      lsof
      mosh
      nix-index
      nix-prefetch-scripts
      nix-prefetch-github
      nmap
      nodejs
      openssl
      procs
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
      yarn
      youtube-dl
      zoxide
    ];
    #username = "moul";
    #homeDirectory = "/home/moul";

    #file = {
    #  ".spacemacs" = { source = spacemacs; };
    #};

    activation = {
      afterWriteBoundary = config.lib.dag.entryAfter [ "writeBoundary"] ''
        $DRY_RUN_CMD ln -sf $VERBOSE_ARG ${configd}/.spacemacs ~/.spacemacs;
        mkdir -p ~/.ssh;
        $DRY_RUN_CMD ln -sf $VERBOSE_ARG ${configd}/assh.yml ~/.ssh/assh.yml;
        assh config build > ~/.ssh/config;
      '';
    };

    sessionVariables = {
      EDITOR = "emacs";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  manual = {
    manpages = {
      enable = true;
    };
  };

  programs = {
    bash = {
      enable = true;
      profileExtra = ''
        # GVM
        # requires:
        #     bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
        source $HOME/.gvm/scripts/gvm
      '';
    };

    bat = {
      enable = true;
      config = {
        style = "plain";
      };
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      userName = "Manfred Touron";
      userEmail = "94029+moul@users.noreply.github.com";
      #signing = {
      #  key = "";
      #  signByDefault = true;
      #};
      aliases = {
        co = "checkout";
      };
      extraConfig = {
        pull.rebase = true;
      };
      delta = {
        enable = true;
      };
      lfs = {
        enable = true;
      };
      ignores = [
        "*~"
        "*.swp"
        "*#"
        ".#*"
        ".DS_Store"
      ];
      extraConfig = {
        core = {
          whitespace = "trailing-space,space-before-tab";
        };
        url."git@github.com:".insteadOf = "https://github.com/";
      };
    };

    go = {
      enable = true;
      goBin = ".local/bin";
    };

    gpg = {
      enable = true;
    };

    home-manager = {
      enable = true;
      path = "…";
    };

    htop = {
      enable = true;
      hideKernelThreads = true;
      hideThreads = true;
      hideUserlandThreads = true;
      treeView = true;
      meters = {
        left = ["LeftCPUs2" "Memory" "Swap" "Load" "Clock"];
        right = ["RightCPUs2" "Tasks" "LoadAverage" "Uptime"];
      };
    };

    man = {
      enable = true;
    };

    #ssh = {
    #  enable = true;
    #  matchBlocks."*".proxyCommand = "assh connect --port=%p %h";
    #};

    kitty = {
      enable = true;
    };

    tmux = {
      enable = true;
      extraConfig = ''
        # custom
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
        set -g status-right '#[fg=colour235,bg=colour235,nobold,nounderscore,noitalics]#[fg=colour121,b#g=colour235] %l:%M %p  %d %b %Y  #[fg=colour238,bg=colour235,nobold,nounderscore,noitalics]#[fg=colou#r22,bg=colour238] #H #[fg=colour154,bg=colour238,nobold,nounderscore,noitalics]#[fg=colour232,bg=colour154]  #(rainbarf --battery --remaining --no-rgb) '
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
      dotDir = ".config/zsh";
      enableCompletion = true;
      enableAutosuggestions = true;
      history = {
        extended = true;
      };
      initExtra = ''
        # ls
        zstyle ':fzf-tab:complete:cd:*' fzf-preview '${pkgs.exa}/bin/exa --color=always --tree --level=1 $realpath'
      '';
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.1.0";
            sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
          };
        }
      ];
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
      shellAliases = with pkgs; {
        ":q" = "exit";
        ".." = "cd ..";
        cat = "${bat}/bin/bat";
      };
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
