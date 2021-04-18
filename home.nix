{ config, pkgs, lib, ... }:

let
  configd = "~/.config/nixpkgs/config";
  em = pkgs.writeScriptBin "em" (builtins.replaceStrings ["\${pkgs.emacs}"] ["${pkgs.emacs}"] (lib.readFile ./config/em));
  nerdsfontLight = (pkgs.nerdfonts.override { fonts = [ "Iosevka" "FiraCode" "Hack" ]; });
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  home.language = (if pkgs.stdenv.isDarwin then {
    base = "en_US.UTF-8";
    address = "en_US.UTF-8";
    collate = "en_US.UTF-8";
    ctype = "en_US.UTF-8";
    measurement = "en_US.UTF-8";
    messages = "en_US.UTF-8";
    monetary = "en_US.UTF-8";
    name = "en_US.UTF-8";
    numeric = "en_US.UTF-8";
    paper = "en_US.UTF-8";
    telephone = "en_US.UTF-8";
    time = "en_US.UTF-8";
  } else {
    base = "C.UTF-8";
    address = "C.UTF-8";
    collate = "C.UTF-8";
    ctype = "C.UTF-8";
    measurement = "C.UTF-8";
    messages = "C.UTF-8";
    monetary = "C.UTF-8";
    name = "C.UTF-8";
    numeric = "C.UTF-8";
    paper = "C.UTF-8";
    telephone = "C.UTF-8";
    time = "C.UTF-8";
  });
  home.packages = with pkgs; [
    ascii
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    aspellDicts.fr
    assh
    bat
    cachix
    coreutils
    cowsay
    curl
    diff-so-fancy
    docker
    docker-buildx
    docker-compose
    du-dust
    em
    emacs-nox
    exa
    fd
    ffmpeg
    file
    fortune
    fzf
    gnumake
    gnupg
    graphviz
    htop
    httpie
    imagemagick
    ipfs
    ispell
    jq
    kitty
    libnotify
    lsof
    mosh
    nerdsfontLight
    nix-index
    nix-info
    nix-prefetch-github
    nix-prefetch-scripts
    nixfmt
    nmap
    nodejs
    openssl
    pre-commit
    procs
    protobuf
    pstree
    screen
    tcpdump
    telnet
    tmux
    tree
    tty-clock
    unzip
    wget
    xdg_utils
    xorg.xeyes
    yarn
    youtube-dl
    zip
    zoxide
  ] ++ lib.optionals stdenv.isDarwin [
    cocoapods
    jazzy
    libffi
    libffi.dev
  ] ++ lib.optionals stdenv.isLinux [
    lshw
  ];
  #home.username = "moul";
  #home.homeDirectory = "/home/moul";

  #home.file = {
  #  ".spacemacs" = { source = spacemacs; };
  #};

  fonts.fontconfig.enable = true;

  home.activation = {
    customEndHook = config.lib.dag.entryAfter [ "reloadSystemd" "writeBoundary" "onFilesChange" "installPackages" ] ''
      $DRY_RUN_CMD ln -sf $VERBOSE_ARG ${configd}/.spacemacs ~/.spacemacs;
      mkdir -p ~/.ssh;
      $DRY_RUN_CMD ln -sf $VERBOSE_ARG ${configd}/assh.yml ~/.ssh/assh.yml;
      assh config build > ~/.ssh/config;
      # FIXME: replace with niv/go2nix
      pushd ~/.config/nixpkgs/config/go
      chmod 711 ~/.ssh
      chmod 600 ~/.ssh/config || true
      if [ ! -d ~/.emacs.d/.git ]; then
        rm -rf ~/.emacs.d.old
        mv ~/.emacs.d ~/.emacs.d.old || true
        git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
      fi
      if [ "$HOME/.nix-profile/bin/go" = "$(which go)" ]; then
        GO="${pkgs.go}/bin/go" make install || true # sometimes it fails because we miss some env vars
      fi
      popd
      mkdir -p ~/.npm-global
      npm config set prefix ~/.npm-global
      npm i -g tern prettier js-beautify eslint babel-eslint eslint-plugin-react
      touch ~/.aliases
    '';
  };

  home.sessionVariables = {
    EDITOR = "em";
    VISUAL = "em";
    GIT_EDITOR = "em";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.npm-global/bin"
  ];

  home.sessionVariablesExtra = ''
    # unset __HM_SESS_VARS_SOURCED to prevent tmux caching
    unset __HM_SESS_VARS_SOURCED
  '';

  manual.manpages = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    profileExtra = ''
      # TMP FIX
      export PATH=$PATH:~/.nix-profile/bin; for file in ~/.nix-profile/etc/profile.d/*.sh; do source $file; done

      # GVM
      # requires:
      #     bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
      source $HOME/.gvm/scripts/gvm
    '';
  };

  programs.bat = {
    enable = true;
    config = {
      style = "plain";
    };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.gh = {
    gitProtocol = "ssh";
  };

  programs.git = {
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
    package = pkgs.buildEnv {
      name = "myGitEnv";
      paths = with pkgs.gitAndTools; [
        git
        delta
        gh
        hub
        tig
      ];
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
        editor = "em";
      };
      pull = {
        rebase = true;
      };
      #url."git@github.com:".insteadOf = "https://github.com/";
      url."ssh://git@git.vptech.eu".insteadOf = "https://git.vptech.eu";
    };
  };

  programs.go = {
    enable = true;
    goBin = ".local/bin";
    package = (pkgs.buildEnv {
      name = "golang";
      paths = with pkgs; [
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
    });
  };

  programs.gpg = {
    enable = true;
  };

  programs.home-manager = {
    enable = true;
    path = "…";
  };

  programs.htop = {
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

  programs.man = {
    enable = true;
  };

  #ssh = {
  #  enable = true;
  #  matchBlocks."*".proxyCommand = "assh connect --port=%p %h";
  #};

  programs.kitty = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
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

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
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
      emacs = "em";
      # emacs typos :)
      emasc = "emacs";
      eamsc = "emacs";
      emaccs = "emacs";
    } // (if pkgs.stdenv.isDarwin then {
      ssh = "${kitty}/bin/kitty +kitten ssh";
    } else {}) // (if pkgs.stdenv.isLinux then {

    } else {});
    profileExtra = ''
      # TMP FIX
      export PATH=$PATH:~/.nix-profile/bin; for file in ~/.nix-profile/etc/profile.d/*.sh; do source $file; done

      # GVM
      # requires:
      #     bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
      source $HOME/.gvm/scripts/gvm
    '';
  };

  xdg.configFile = {
    "kitty/kitty.conf".source = ./config/kitty.conf;
  };

  services.gpg-agent = {
    #enable = true;
    defaultCacheTtl = 1800;
    #enableSshSupport = true;
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
    pinentryFlavor = "emacs";
  };

  #virtualisation.docker = {
  #  enable = true;
  #};

  #xsession = {
  #  enable = true;
  #  windowManager = {
  #    command = "";
  #  };
  #};
}
