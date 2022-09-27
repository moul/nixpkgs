{ config, lib, pkgs, ... }:

{
  # Bat, a substitute for cat.
  # https://github.com/sharkdp/bat
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.bat.enable
  programs.bat.enable = true;
  programs.bat.config = {
    style = "plain";
  };

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  # Zoxide, a faster way to navigate the filesystem
  # https://github.com/ajeetdsouza/zoxide
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.zoxide.enable
  programs.zoxide.enable = true;

  home.packages = with pkgs; [
    # Some basics
    abduco # lightweight session management
    ascii
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    aspellDicts.fr
    assh
    bandwhich # display current network utilization by process
    bottom # fancy version of `top` with ASCII graphs
    browsh # in terminal browser
    coreutils
    cowsay
    curl
    diff-so-fancy
    (nerdfonts.override { fonts = ["Iosevka" "FiraCode" "Hack"]; })
    docker
    du-dust # fancy version of `du`
    em
    emacs-nox
    entr
    exa # fancy version of `ls`
    fd # fancy version of `find`
    ffmpeg
    file
    fzf
    gist
    git-crypt
    gnumake
    gnupg
    graphviz
    hub
    htop # fancy version of `top`
    httpie
    hyperfine # benchmarking tool
    imagemagick
    inetutils
    ipfs
    ispell
    go
    mosh # wrapper for `ssh` that better and not dropping connections
    nodePackages.speed-test # nice speed-test tool
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
    unixtools.watch

    # Useful nix related tools
    cachix # adding/managing alternative binary caches hosted by Cachix
    comma # run software from without installing it
    niv # easy dependency management for nix projects
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

  ] ++ lib.optionals stdenv.isDarwin [
    # docker-desktop
    m-cli # useful macOS CLI commands
    prefmanager # tool for working with macOS defaults
  ];
}
