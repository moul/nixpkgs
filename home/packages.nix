{ config, lib, pkgs, ... }:

let rust_home = "${config.xdg.dataHome}/rust";
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

  # Go Env
  programs.go = {
    enable = true;
    goPath = ".local/share/go";
    goBin = ".local/bin";
    package = pkgs.go;
  };

  # rust env
  # setup cargo home
  home.sessionVariables.CARGO_HOME = "${rust_home}/cargo";
  # setup rustup
  home.sessionVariables.RUSTUP_HOME = "${rust_home}/rustup";
  home.activation.rustup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export CARGO_HOME="${rust_home}/cargo"
    export RUSTUP_HOME="${rust_home}/rustup"
    ${pkgs.rustup}/bin/rustup toolchain install stable 1>/dev/null
  '';

  home.sessionPath = [ "${rust_home}/cargo/bin" "${rust_home}/rustup/bin" ];

  # Bat, a substitute for cat.
  # https://github.com/sharkdp/bat
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.bat.enable
  programs.bat.enable = true;
  programs.bat.themes = {
    catppuccin-macchiato = builtins.readFile (pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "bat";
      rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
      sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
    } + "/Catppuccin-macchiato.tmTheme");
  };
  programs.bat.config = {
    style = "plain";
    theme = "catppuccin-macchiato";
  };

  home.packages = with pkgs;
    [
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
      my-loon

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
      rustup

      # ruby
      ruby_3_1

      # js
      nodejs-18_x
      nodePackages.pnpm
      yarn

      # python
      (python39.withPackages
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
      rnix-lsp
      cachix # adding/managing alternative binary caches hosted by Cachix
      lorri # improve `nix-shell` experience in combination with `direnv`
      niv # easy dependency management for nix projects
      nix-prefetch
      nix-prefetch-git
      nixfmt
    ] ++ lib.optionals stdenv.isDarwin [ cocoapods ]
    ++ lib.optionals stdenv.isLinux [ docker docker-compose ];
}
