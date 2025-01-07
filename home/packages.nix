{ config, lib, pkgs, ... }:

let
  inherit (config.home) user-info homeDirectory;
  rust_home = "${config.xdg.dataHome}/rust";
  #em = pkgs.writeScriptBin "em"
  #  (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${pkgs.emacsNativeComp}" ]
  #    (lib.readFile ./../config/em));
  #raw-emacs = pkgs.writeScriptBin "raw-emacs"
  #  (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${pkgs.emacsNativeComp}" ]
  #    (lib.readFile ./../config/raw-emacs));
  em = pkgs.writeScriptBin "em"
    (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${pkgs.emacs}" ]
      (lib.readFile ./../config/em));
  raw-emacs = pkgs.writeScriptBin "raw-emacs"
    (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${pkgs.emacs}" ]
      (lib.readFile ./../config/raw-emacs));
in {
  # ssh
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPath = "${config.xdg.cacheHome}/ssh-%u-%r@%h:%p";
    controlPersist = "1800";
    forwardAgent = true;
    serverAliveInterval = 60;
    hashKnownHosts = true;
    # on darwin use 1password agent
    extraConfig = lib.mkIf pkgs.stdenv.isDarwin ''
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };

  # disable manual
  # Some weird bug
  # https://github.com/NixOS/nixpkgs/issues/196651
  manual.html.enable = false;
  manual.manpages.enable = false;

  targets.genericLinux.enable = pkgs.stdenv.isLinux;

  # Go Env
  programs.go = {
    enable = true;
    #goPath = ".local/share/go";
    goPath = "go";
    goBin = ".local/bin";
    package = pkgs.go;
  };

  # rust env
  ## setup cargo home
  #home.sessionVariables.CARGO_HOME = "${rust_home}/cargo";
  ## setup rustup
  #home.sessionVariables.RUSTUP_HOME = "${rust_home}/rustup";
  #home.activation.rustup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #  export CARGO_HOME="${rust_home}/cargo"
  #  export RUSTUP_HOME="${rust_home}/rustup"
  #  ${pkgs.rustup}/bin/rustup toolchain install stable 1>/dev/null
  #'';

  home.sessionPath = [
    # rust
    "${rust_home}/cargo/bin"
    "${rust_home}/rustup/bin"
    # go
    "${homeDirectory}/go/bin"
  ];

  # Bat, a substitute for cat.
  # https://github.com/sharkdp/bat
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.bat.enable

  programs.bat.enable = true;

  programs.bat.themes = {
    catppuccin-macchiato = {
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "bat";
        rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
        sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
      };
      file = "/Catppuccin-macchiato.tmTheme";
    };
  };

  programs.bat.config = {
    style = "plain";
    theme = "catppuccin-macchiato";
  };

  home.packages = with pkgs;
    [
      # custom
      em
      raw-emacs

      # Some basics
      abduco # lightweight session management
      ascii
      #      aspell
      #      aspellDicts.en
      #      aspellDicts.en-computers
      #      aspellDicts.en-science
      #      aspellDicts.fr
      assh
      bandwhich # display current network utilization by process
      bottom # fancy version of `top` with ASCII graphs
      browsh # in terminal browser
      coreutils
      cowsay
      curl
      diff-so-fancy
      #(nerdfonts.override { fonts = [ "Iosevka" "FiraCode" "Hack" ]; })
      nerd-fonts.iosevka
      nerd-fonts.fira-code
      docker
      du-dust # fancy version of `du`
      #emacs-nox
      entr
      #exa # fancy version of `ls`
      expect
      fd # fancy version of `find`
      ffmpeg
      file
      fzf
      gist
      git-crypt
      ghostscript
      gnumake
      gnupg
      graphviz
      hub
      htop # fancy version of `top`
      httpie
      hyperfine # benchmarking tool
      imagemagick
      inetutils
      #ipfs
      ispell
      mosh # wrapper for `ssh` that better and not dropping connections
      nodePackages.speed-test # nice speed-test tool
      nodejs
      nmap
      openssl
      parallel # runs commands in parallel
      pre-commit
      # procs
      protobuf
      pstree
      # python3Packages.shell-functools # a collection of functional programming tools for the shell
      ripgrep # better version of `grep`
      socat
      #sudo
      tcpdump
      tealdeer # rust implementation of `tldr`
      thefuck
      tree
      tmuxinator
      # tty-clock
      unrar # extract RAR archives
      unzip
      wget
      xz # extract XZ archives
      jq
      yq
      unixtools.watch
      #youtube-dl

      # Useful nix related tools
      vivid
      cachix # adding/managing alternative binary caches hosted by Cachix
      comma # run software from without installing it
      # niv # easy dependency management for nix projects
      nixfmt
      nix-diff
      nix-index
      nix-info
      nix-prefetch-github
      nix-prefetch-scripts
      nix-tree # interactively browse dependency graphs of Nix derivations
      nix-update # swiss-knife for updating nix packages
      nixpkgs-review # review pull-requests on nixpkgs
      nodePackages.node2nix
      statix # lints and suggestions for the Nix programming language

      # Some basics
      tig
      mosh # wrapper for `ssh` that better and not dropping connections
      unrar # extract RAR archives
      eza # fancy version of `ls`
      btop # fancy version of `top`
      tmate # instant terminal sharing
      fd # fancy version of `find`
      most
      parallel # runs commands in parallel
      socat
      lazydocker # The lazier way to manage everything docker
      lazygit # The lazier way to manage everything git
      less
      tree # list contents of directories in a tree-like format.
      coreutils
      jq
      (ripgrep.override { withPCRE2 = true; }) # better version of grep
      curl # transfer a URL
      wget # The non-interactive network downloader.
      entr
      cmake
      gnupg
      fzf

      # my
      my-libvterm
      #my-loon
      #my-gnolint

      # stable
      procs # fancy version of `ps`

      # aspell
      (aspellWithDicts (d: [
        d.en
        d.fr
        d.en-computers
        d.en-science
      ])) # interactive spell checker
      aspellDicts.fr
      aspellDicts.en
      aspellDicts.en-science
      aspellDicts.en-computers

      # rust
      pkgs-stable.rustup

      # ruby
      pkgs-stable.ruby_3_1

      # js
      pkgs-stable.nodejs-18_x
      pkgs-stable.nodePackages.pnpm
      pkgs-stable.yarn

      # python
      (pkgs-stable.python39.withPackages
        (p: with p; [ virtualenv pip mypy pylint yapf setuptools ]))
      pipenv

      # go tools
      gofumpt
      gopls # see overlay
      delve
      # exclude bundle
      (gotools.overrideDerivation
        (oldAttrs: { excludedPackages = [ "bundle" ]; }))

      # gotools

      # Useful nix related tools
      nixpkgs-fmt
      #rnix-lsp
      cachix # adding/managing alternative binary caches hosted by Cachix
      lorri # improve `nix-shell` experience in combination with `direnv`
      niv # easy dependency management for nix projects
      nix-prefetch
      nix-prefetch-git
      nixfmt
    ] ++ lib.optionals stdenv.isDarwin [ cocoapods ]
    ++ lib.optionals stdenv.isLinux [ docker docker-compose ];
}
