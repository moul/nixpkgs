{ config, pkgs, lib, ... }:

let
  configd = "~/.config/nixpkgs/config";
  em = pkgs.writeScriptBin "em"
    (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${pkgs.emacsGcc}" ]
      (lib.readFile ./config/em));
  raw-emacs = pkgs.writeScriptBin "raw-emacs"
    (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${pkgs.emacsGcc}" ]
      (lib.readFile ./config/raw-emacs));
  nerdsfontLight =
    (pkgs.nerdfonts.override { fonts = [ "Iosevka" "FiraCode" "Hack" ]; });
  theme = import ./theme.nix;
  #tmuxConf = lib.readFile ./config/.tmux.conf;
in {
  #nixpkgs.config = { allowUnfree = true; };

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
  home.packages = with pkgs;
    [
      ascii
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      aspellDicts.fr
      assh
      bat
      bazel
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
      gist
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
      nixfmt
      nix-diff
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
      raw-emacs
      screen
      tcpdump
      telnet
      tmux
      tmuxinator
      tree
      tty-clock
      unixtools.watch
      unzip
      wget
      xdg_utils
      xorg.xeyes
      yarn
      youtube-dl
      zip
      zoxide
    ] ++ lib.optionals stdenv.isDarwin [ cocoapods jazzy libffi libffi.dev ]
    ++ lib.optionals stdenv.isLinux [ lshw ];
  #home.username = "moul";
  #home.homeDirectory = "/home/moul";

  home.file.".emacs.d" = {
    source = pkgs.spacemacs;
    recursive = true;
  };

  fonts.fontconfig.enable = true;

  home.activation = {
    customEndHook = config.lib.dag.entryAfter [
      "reloadSystemd"
      "writeBoundary"
      "onFilesChange"
      "installPackages"
    ] ''
      # spacemacs
      ln -sf ${configd}/.spacemacs ~/.spacemacs;

      # ssh
      mkdir -p ~/.ssh;
      ln -sf ${configd}/assh.yml ~/.ssh/assh.yml;
      assh config build > ~/.ssh/config;
      chmod 711 ~/.ssh
      chmod 600 ~/.ssh/config || true

      # go
      # FIXME: replace with niv/go2nix
      #if [ "$HOME/.nix-profile/bin/go" = "$(which go)" ]; then
      #  pushd ~/.config/nixpkgs/config/go
      #  GO="${pkgs.go}/bin/go" make install || true # sometimes it fails because we miss some env vars
      #  popd
      #fi

      # npm
      #mkdir -p ~/.npm-global
      #npm config set prefix ~/.npm-global
      #npm i -g tern prettier js-beautify eslint babel-eslint eslint-plugin-react
      #touch ~/.aliases
    '';
  };

  home.sessionVariables = {
    EDITOR = "em";
    VISUAL = "em";
    GIT_EDITOR = "em";
  };

  home.sessionPath =
    [ "$HOME/.local/bin" "$HOME/go/bin" "$HOME/.npm-global/bin" ];

  home.sessionVariablesExtra = ''
    # unset __HM_SESS_VARS_SOURCED to prevent tmux caching
    unset __HM_SESS_VARS_SOURCED
  '';

  manual.manpages = { enable = true; };

  programs.bash = {
    enable = true;
    profileExtra = ''
      # TMP FIX
      export PATH=$PATH:~/.nix-profile/bin; for file in ~/.nix-profile/etc/profile.d/*.sh; do source $file; done

      # GVM
      # requires:
      #     bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
      if [ -f $HOME/.gvm/scripts/gvm ]; then
            source $HOME/.gvm/scripts/gvm
      fi
    '';
  };

  programs.bat = {
    enable = true;
    config = { style = "plain"; };
  };

  programs.command-not-found = { enable = true; };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.gh = { gitProtocol = "ssh"; };

  programs.git = {
    enable = true;
    userName = "Manfred Touron";
    userEmail = "94029+moul@users.noreply.github.com";
    #signing = {
    #  key = "";
    #  signByDefault = true;
    #};
    aliases = { co = "checkout"; };
    package = pkgs.buildEnv {
      name = "myGitEnv";
      paths = with pkgs.gitAndTools; [
        gitFull
        delta
        gh
        hub
        tig
        git-crypt
        git-bug
        git-appraise
        #git-pr-mirror
        #git-remote-ipfs
        lab
        git-crypt
        git-secrets
        git-filter-repo
        git-absorb
        #git-get
        stagit
      ];
    };
    delta = { enable = true; };
    lfs = { enable = true; };
    ignores = [ "*~" "*.swp" "*#" ".#*" ".DS_Store" ];
    extraConfig = {
      core = {
        whitespace = "trailing-space,space-before-tab";
        editor = "em";
      };
      pull = { rebase = true; };
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

  programs.gpg = { enable = true; };

  programs.home-manager = {
    enable = true;
    path = "…";
  };

  programs.htop = {
    enable = true;
    settings = {
      hide_kernel_threads = true;
      hide_threads = true;
      hide_userland_threads = true;
      tree_view = true;
      left_metters = [ "LeftCPUs2" "Memory" "Swap" "Load" "Clock" ];
      right_metters = [ "RightCPUs2" "Tasks" "LoadAverage" "Uptime" ];
    };
  };

  programs.man = { enable = true; };

  #ssh = {
  #  enable = true;
  #  matchBlocks."*".proxyCommand = "assh connect --port=%p %h";
  #};

  programs.kitty = {
    enable = true;
    extraConfig = lib.strings.concatStrings [
      (lib.strings.fileContents ./config/kitty.conf)
      ''
        #
        # THEME: ${theme.name}
        #
        background ${theme.background}
        color0 ${theme.color0}
        color1 ${theme.color1}
        color2 ${theme.color2}
        color3 ${theme.color3}
        color4 ${theme.color4}
        color5 ${theme.color5}
        color6 ${theme.color6}
        color7 ${theme.color7}
        color8 ${theme.color8}
        color9 ${theme.color9}
        color10 ${theme.color10}
        color11 ${theme.color11}
        color12 ${theme.color12}
        color13 ${theme.color13}
        color14 ${theme.color14}
        color15 ${theme.color15}
        cursor ${theme.cursor}
        foreground ${theme.foreground}
        selection_background ${theme.selection}
        selection_foreground ${theme.selected-text}
      ''
    ];
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsGcc;
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    keyMode = "emacs";
    escapeTime = 20;
    clock24 = true;
    baseIndex = 1;
    terminal = "screen-256color";
    extraConfig = lib.strings.fileContents ./config/.tmux.conf;
    plugins = with pkgs; [
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
    history = { extended = true; };
    initExtra = ''
      # ls
      zstyle ':fzf-tab:complete:cd:*' fzf-preview '${pkgs.exa}/bin/exa --color=always --tree --level=1 $realpath'
    '';
    plugins = [{
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.1.0";
        sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
      };
    }];
    oh-my-zsh = {
      enable = true;
      plugins = [ "git-extras" "git" "gitfast" "github" ];
      theme = "agnoster";
      #theme = "frozencow";
    };
    loginExtra = ''
      setopt extendedglob
      source $HOME/.aliases
      bindkey '^R' history-incremental-pattern-search-backward
      bindkey '^F' history-incremental-pattern-search-forward
    '';
    shellAliases = with pkgs;
      {
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
      } else
        { }) // (if pkgs.stdenv.isLinux then
          {

          }
        else
          { });
    profileExtra = ''
      # TMP FIX
      export PATH=$PATH:~/.nix-profile/bin; for file in ~/.nix-profile/etc/profile.d/*.sh; do source $file; done

      # GVM
      # requires:
      #     bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
      if [ -f $HOME/.gvm/scripts/gvm ]; then
            source $HOME/.gvm/scripts/gvm
      fi
    '';
  };

  xdg.configFile = {
    #"kitty/kitty.conf".source = ./config/kitty.conf;
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
