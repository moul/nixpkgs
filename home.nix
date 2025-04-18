# Consolidated Home Manager Modules
{ config, lib, pkgs, ... }:

let
  # === From asdf.nix ===
  asdf-config = pkgs.writeText "asdfrc" ''
    # See the docs for explanations: https://asdf-vm.com/manage/configuration.html

    legacy_version_file = no
    use_release_candidates = no
    always_keep_download = no
    disable_plugin_short_name_repository = no
    ${if pkgs.stdenv.isDarwin then
      "java_macos_integration_enable = yes"
    else
      ""}
  '';

  # === From config.nix ===
  inherit (pkgs) stdenv;
  inherit (lib) mkIf;

  # === From emacs.nix ===
  my-emacs = pkgs.emacs30-nox.override {
    withNativeCompilation = false;
    noGui = true;
  };
  em = pkgs.writeScriptBin "em"
    (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${my-emacs}" ]
      (lib.readFile ./config/em));
  raw-emacs-old = pkgs.writeScriptBin "raw-emacs-old"
    (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${my-emacs}" ]
      (lib.readFile ./config/raw-emacs));

  # === From jankyborders.nix ===
  janky-theme =
    config.colors.catppuccin-macchiato; # Renamed from 'theme' to avoid clash
  janky-yellow = janky-theme.namedColors.yellow;
  janky-black = janky-theme.namedColors.black;
  janky-hexYellow =
    builtins.substring 1 (builtins.stringLength janky-yellow) janky-yellow;
  janky-hexBlack =
    builtins.substring 1 (builtins.stringLength janky-black) janky-black;

  # === From kitty.nix ===
  kitty-theme =
    config.colors.manfred-touron; # Renamed from 'theme' to avoid clash

  # === From packages.nix ===
  inherit (config.home) user-info homeDirectory;
  rust_home = "${config.xdg.dataHome}/rust";

  # === From shells.nix ===
  # user-info, homeDirectory already inherited from packages.nix
  shells-configDir = ".config"; # Renamed to avoid clash
  shells-cacheDir = ".cache"; # Renamed to avoid clash
  shells-dataDir = ".local/share"; # Renamed to avoid clash
  oh-my-zsh-custom = "${shells-configDir}/oh-my-zsh";

  restart-service = pkgs.writeShellScriptBin "restart-service" ''
    set -e

    plist_name="$1"
    plist_path=$(find $HOME/Library/LaunchAgents -name "$plist_name" 2>/dev/null | head -n 1)

    if [[ -z "$plist_path" ]]; then
        echo "Unable to find $plist_name"
        exit 1
    fi

    echo "restarting $plist_name"

    major_version=$(sw_vers -productVersion | cut -d. -f2)

    if [[ $major_version -ge 16 ]]; then
        # For macOS Big Sur and later
        launchctl bootout system "$plist_path" && launchctl bootstrap system "$plist_path"
    else
        # For macOS Catalina and earlier
        launchctl unload "$plist_path" && launchctl load "$plist_path"
    fi
  '';

in lib.mkMerge [
  # === asdf.nix ===
  {
    home.file."${config.xdg.configHome}/asdf/asdfrc" = {
      source = asdf-config;
    };
    home.sessionVariables = {
      ASDF_CONFIG_FILE = "${config.xdg.configHome}/asdf/asdfrc";
      ASDF_DATA_DIR = "${config.xdg.dataHome}/asdf";
      ASDF_DIR = "${pkgs.asdf-vm}/share/asdf-vm";
    };
  }

  # === colors.nix ===
  {
    colors.catppuccin-macchiato = {
      colors = {
        color0 = "#181926";
        color8 = "#1e2030";
        color1 = "#ed8796";
        color9 = "#ee99a0";
        color2 = "#a6da95";
        color10 = "#8bd5ca";
        color3 = "#f5a97f";
        color11 = "#eed49f";
        color4 = "#8aadf4";
        color12 = "#b7bdf8";
        color5 = "#f5bde6";
        color13 = "#c6a0f6";
        color6 = "#91d7e3";
        color14 = "#7dc4e4";
        color7 = "#f4dbd6";
        color15 = "#f0c6c6";
        color16 = "#cad3f5";
        color17 = "#24273a";
        color18 = "#1e2030";
        color19 = "#181926";
        color20 = "#494d64";
        color21 = "none";
      };
      namedColors = {
        black = "color0";
        brightBlack = "color8";
        red = "color1";
        brightRed = "color9";
        green = "color2";
        brightGreen = "color10";
        yellow = "color3";
        brightYellow = "color11";
        blue = "color4";
        brightBlue = "color12";
        magenta = "color5";
        brightMagenta = "color13";
        cyan = "color6";
        brightCyan = "color14";
        white = "color7";
        brightWhite = "color15";
        text = "color16";
        base = "color17";
        mantle = "color18";
        crust = "color19";
        surface = "color20";
        none = "color21";
      };
      terminal = {
        bg = "base";
        fg = "text";
        cursorBg = "white";
        cursorFg = "black";
        selectionBg = "white";
        selectionFg = "black";
      };
      pkgThemes.kitty = {
        url_color = "blue";
        tab_bar_background = "none";
        active_tab_background = "yellow";
        active_tab_foreground = "black";
        inactive_tab_background = "crust";
        inactive_tab_foreground = "text";
        active_border_color = "yellow";
        inactive_border_color = "surface";
        bell_border_color = "brightBlue";
      };
    };
    colors.material = {
      colors = {
        color0 = "#546e7a";
        color8 = "#b0bec5";
        color1 = "#ff5252";
        color9 = "#ff8a80";
        color2 = "#5cf19e";
        color10 = "#b9f6ca";
        color3 = "#ffd740";
        color11 = "#ffe57f";
        color4 = "#40c4ff";
        color12 = "#80d8ff";
        color5 = "#ff4081";
        color13 = "#ff80ab";
        color6 = "#64fcda";
        color14 = "#a7fdeb";
        color7 = "#ffffff";
        color15 = "#ffffff";
        color16 = "#eceff1";
        color17 = "#263238";
        color18 = "#607d8b";
      };
      namedColors = {
        black = "color0";
        brightBlack = "color8";
        red = "color1";
        brightRed = "color9";
        green = "color2";
        brightGreen = "color10";
        yellow = "color3";
        brightYellow = "color11";
        blue = "color4";
        brightBlue = "color12";
        magenta = "color5";
        brightMagenta = "color13";
        cyan = "color6";
        brightCyan = "color14";
        white = "color7";
        brightWhite = "color15";
        brightGray = "color16";
        gunmetal = "color17";
        steelTeal = "color18";
      };
      terminal = {
        bg = "base";
        fg = "text";
        cursorBg = "white";
        cursorFg = "black";
        selectionBg = "white";
        selectionFg = "black";
      };
      pkgThemes.kitty = {
        url_color = "blue";
        tab_bar_background = "black";
        active_tab_background = "gunmetal";
        active_tab_foreground = "green";
        inactive_tab_background = "black";
        inactive_tab_foreground = "brightGreen";
      };
    };
    colors.manfred-touron = {
      colors = {
        color0 = "#000000";
        color8 = "#4e4e4e";
        color1 = "#ff0000";
        color9 = "#ff008b";
        color2 = "#51ff0f";
        color10 = "#62c750";
        color3 = "#e7a800";
        color11 = "#f4ff00";
        color4 = "#3950d7";
        color12 = "#70a5ed";
        color5 = "#d336b1";
        color13 = "#b867e6";
        color6 = "#66b2ff";
        color14 = "#00d4fc";
        color7 = "#cecece";
        color15 = "#ffffff";
        color16 = "#eceff1";
        color17 = "#263238";
        color18 = "#607d8b";
        color19 = "#181926";
        color20 = "#494d64";
        color21 = "none";
      };
      namedColors = {
        black = "color0";
        brightBlack = "color8";
        red = "color1";
        brightRed = "color9";
        green = "color2";
        brightGreen = "color10";
        yellow = "color3";
        brightYellow = "color11";
        blue = "color4";
        brightBlue = "color12";
        magenta = "color5";
        brightMagenta = "color13";
        cyan = "color6";
        brightCyan = "color14";
        white = "color7";
        brightWhite = "color15";
        text = "color16";
        base = "color0";
        mantle = "color18";
        crux = "color19";
        surface = "color20";
        none = "color21";
        brightGray = "color16";
        gunmetal = "color17";
        steelTeal = "color18";
      };
      terminal = {
        bg = "base";
        fg = "text";
        cursorBg = "white";
        cursorFg = "black";
        selectionBg = "white";
        selectionFg = "black";
      };
      pkgThemes.kitty = {
        url_color = "blue";
        tab_bar_background = "black";
        active_tab_background = "gunmetal";
        active_tab_foreground = "green";
        inactive_tab_background = "black";
        inactive_tab_foreground = "brightGreen";
        active_border_color = "yellow";
        inactive_border_color = "surface";
        bell_border_color = "brightBlue";
      };
    };
  }

  # === config.nix ===
  {
    home.file."/.config/btop" = {
      source = "${lib.cleanSource ./config/btop}";
      recursive = true;
    };
    home.file.".npmrc" = with pkgs; {
      source = writeText "npmrc" ''
        prefix=${config.xdg.dataHome}/node_modules
      '';
    };
    # sketchybar
    home.file.".aspell.config" = with pkgs; {
      source = writeText "aspell.conf" ''
        dict-dir ""
        master en_US
        extra-dicts en en-computers.rws en-science.rws fr.rws
      '';
    };
  }

  # === emacs.nix ===
  {
    programs.emacs = {
      enable = true;
      package = my-emacs;
      extraConfig = pkgs.lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ''
        ; macOS ls doesn't support --dired
        (setq dired-use-ls-dired nil)
      '';
      extraPackages = epkgs:
        let
          # sops = epkgs.trivialBuild { pname = "sops"; version = "0.1.4"; src = pkgs.fetchurl { url = "https://raw.githubusercontent.com/djgoku/sops/v0.1.4/sops.el"; hash = "sha256-GmEexfdDLQfgUQ2WrVo/C9edF9/NuocO3Dpnv3F7/qA="; }; };
        in with epkgs; [
          org
          better-defaults
          diminish
          epkgs."ido-completing-read+"
          smex
          flycheck
          envrc
          company
          dockerfile-mode
          go-mode
          kubel
          lsp-mode
          lsp-pyright
          lsp-ui
          magit
          markdown-mode
          nix-mode
          nix-sandbox
          pretty-mode
          projectile
          yaml-mode
          polymode
        ];
    };
    home.packages = with pkgs; [ sqlite em raw-emacs-old ];
    home.file.".emacs.d/init.el" = { source = ./config/emacs/init.el; };
    home.file.".emacs.d/config.org" = { source = ./config/emacs/config.org; };
    programs.zsh.shellAliases.emacs = "em";
    programs.zsh.shellAliases.emasc = "em";
    programs.zsh.shellAliases.eamsc = "em";
    programs.zsh.shellAliases.emaccs = "em";
    programs.zsh.shellAliases.emacss = "em";
    programs.zsh.shellAliases.raw-emacs = "${my-emacs}/bin/emacs";
  }

  # === git.nix ===
  {
    programs.git = {
      enable = true;
      userEmail = config.home.user-info.email;
      userName = config.home.user-info.username;
      extraConfig = {
        #core.editor = "em";
        core.whitespace = "trailing-space,space-before-tab";
        diff.colorMoved = "default";
        pull.rebase = true;
      };
      ignores = [ "*~" "*.swp" "*#" ".#*" ".DS_Store" ];
      delta.enable = true;
      lfs.enable = true;
      aliases = {
        lg =
          "log --graph --abbrev-commit --decorate --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(italic)- %an%C(reset)%C(magenta bold)%d%C(reset)' --all";
      };
    };
    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
  }

  # === jankyborders.nix (Commented out as in flake.nix) ===
  # {
  #   programs.jankyborders = {
  #     enable = true;
  #     config = {
  #       style = "round";
  #       width = "8.0";
  #       hidpi = "off";
  #       active_color = "0xff${janky-hexYellow}";
  #       inactive_color = "0xff${janky-hexBlack}";
  #     };
  #   };
  # }

  # === kitty.nix ===
  {
    programs.kitty = {
      enable = true;
      settings = {
        font_family = "Iosevka Nerd Font Mono";
        font_size = "12.0";
        adjust_line_height = "100%";
        disable_ligatures = "cursor";
        hide_window_decorations = "titlebar-only";
        window_padding_width = "5";
        window_border_width = "1pt";
        scrollback_pager_history_size = 100;
        macos_option_as_alt = "yes";
        startup_session = "default-session.conf";
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_title_template = "{index}: {title}";
        active_tab_font_style = "bold";
        inactive_tab_font_style = "normal";
        enabled_layouts = "horizontal,grid,splits,vertical";
        enable_audio_bell = "no";
        bell_on_tab = "yes";
        background_opacity = "1.0";
        kitty_mod = "ctrl+alt";
        font_features =
          "+cv02 +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +ss10 +zero +onum";
      };
      extras.useSymbolsFromNerdFont = "FiraCode Nerd Font Mono";
      extras.colors = {
        enable = true;
        dark = kitty-theme.pkgThemes.kitty;
      };
      keybindings = {
        "cmd+t" = "new_tab_with_cwd";
        "kitty_mod+l" = "next_layout";
        "cmd+d" = "launch --cwd=current --location=vsplit";
        "cmd+shift+d" = "launch --cwd=current --location=hsplit";
        "shift+cmd+up" = "move_window up";
        "shift+cmd+left" = "move_window left";
        "shift+cmd+right" = "move_window right";
        "shift+cmd+down" = "move_window down";
        "kitty_mod+left" = "neighboring_window left";
        "kitty_mod+right" = "neighboring_window right";
        "kitty_mod+up" = "neighboring_window up";
        "kitty_mod+down" = "neighboring_window down";
        "cmd+k" =
          "combine : clear_terminal scrollback active : send_text normal,application x0c";
        "cmd+1" = "goto_tab 1";
        "cmd+2" = "goto_tab 2";
        "cmd+3" = "goto_tab 3";
        "cmd+4" = "goto_tab 4";
        "cmd+5" = "goto_tab 5";
        "cmd+6" = "goto_tab 6";
        "cmd+7" = "goto_tab 7";
        "cmd+8" = "goto_tab 8";
        "cmd+9" = "goto_tab 9";
        "kitty_mod+equal" = "change_font_size all +1.0";
        "kitty_mod+minus" = "change_font_size all -1.0";
        "kitty_mod+0" = "change_font_size all 0";
      };
    };
    programs.truecolor = {
      enable = true;
      useterm = "xterm-kitty";
      terminfo = "${pkgs.pkgs-stable.kitty.terminfo.outPath}/share/terminfo";
    };
  }

  # === packages.nix ===
  {
    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPath = "${config.xdg.cacheHome}/ssh-%u-%r@%h:%p";
      controlPersist = "1800";
      forwardAgent = true;
      serverAliveInterval = 60;
      hashKnownHosts = true;
      extraConfig = lib.mkIf pkgs.stdenv.isDarwin ''
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';
    };
    manual.html.enable = false;
    manual.manpages.enable = false;
    targets.genericLinux.enable = pkgs.stdenv.isLinux;
    programs.go = {
      enable = true;
      goPath = "go";
      goBin = ".local/bin";
      package = pkgs.go;
    };
    home.sessionPath = [
      "${rust_home}/cargo/bin"
      "${rust_home}/rustup/bin"
      "${homeDirectory}/go/bin"
    ];
    programs.bat = {
      enable = true;
      themes.catppuccin-macchiato = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
        file = "/Catppuccin-macchiato.tmTheme";
      };
      config = {
        style = "plain";
        theme = "catppuccin-macchiato";
      };
    };
    home.packages = with pkgs;
      [
        abduco
        ascii
        assh
        bandwhich
        bottom
        browsh
        coreutils
        curl
        diff-so-fancy
        nerd-fonts.iosevka
        nerd-fonts.fira-code
        du-dust
        entr
        expect
        fd
        file
        fzf
        gist
        git-crypt
        ghostscript
        gnumake
        gnupg
        graphviz
        hub
        htop
        httpie
        hyperfine
        imagemagick
        inetutils
        ispell
        mosh
        nodePackages.speed-test
        nodejs
        nmap
        openssl
        parallel
        pre-commit
        protobuf
        pstree
        ripgrep
        socat
        tcpdump
        tealdeer
        thefuck
        tree
        tmuxinator
        unrar
        unzip
        wget
        xz
        jq
        yq
        unixtools.watch
        vivid
        cachix
        comma
        nixfmt-classic
        nix-diff
        nix-index
        nix-info
        nix-prefetch-github
        nix-prefetch-scripts
        nix-tree
        nix-update
        nixpkgs-review
        nodePackages.node2nix
        statix
        tig
        mosh
        unrar
        eza
        btop
        tmate
        fd
        most
        parallel
        socat
        lazydocker
        lazygit
        less
        tree
        coreutils
        jq
        (ripgrep.override { withPCRE2 = true; })
        curl
        wget
        entr
        cmake
        gnupg
        fzf
        my-libvterm
        pkgs-stable.procs
        (aspellWithDicts (d: [ d.en d.fr d.en-computers d.en-science ]))
        aspellDicts.fr
        aspellDicts.en
        aspellDicts.en-science
        aspellDicts.en-computers
        pkgs-stable.rustup
        pkgs-stable.ruby_3_1
        pkgs-stable.nodejs-18_x
        pkgs-stable.nodePackages.pnpm
        pkgs-stable.yarn
        (pkgs-stable.python39.withPackages
          (p: with p; [ virtualenv pip mypy pylint yapf setuptools ]))
        pipenv
        gofumpt
        gopls
        delve
        (gotools.overrideDerivation
          (oldAttrs: { excludedPackages = [ "bundle" ]; }))
        nixpkgs-fmt
        cachix
        lorri
        niv
        nix-prefetch
        nix-prefetch-git
        nixfmt-classic
      ] ++ lib.optionals stdenv.isDarwin [ cocoapods ]
      ++ lib.optionals stdenv.isLinux [ docker docker-compose ];
  }

  # === shells.nix ===
  {
    xdg = {
      enable = true;
      configHome = "${homeDirectory}/${shells-configDir}";
      cacheHome = "${homeDirectory}/${shells-cacheDir}";
      dataHome = "${homeDirectory}/${shells-dataDir}";
    };
    home.sessionPath = [
      "${homeDirectory}/.local/bin"
      "${config.xdg.dataHome}/node_modules/bin"
      "${homeDirectory}/go/bin"
    ];
    home.sessionVariables = {
      LC_ALL = "en_US.UTF-8";
      FZF_BASE = "${pkgs.fzf}/share/fzf";
      TERMINFO_DIRS =
        "${pkgs.pkgs-stable.kitty.terminfo.outPath}/share/terminfo:$TERMINFO_DIRS";
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.htop = {
      enable = true;
      settings.show_program_path = true;
    };
    programs.zoxide = { enable = true; };
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      plugins = [{
        name = "p10k-config";
        src = lib.cleanSource ./config/zsh/p10k;
        file = "config.zsh";
      }];
      enableCompletion = true;
      completionInit = "autoload -U compinit && compinit -i";
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        custom = "${config.xdg.configHome}/oh-my-zsh";
        extras = {
          themes = [{
            name = "powerlevel10k";
            source = pkgs.zsh-plugins.powerlevel10k;
          }];
          plugins = [
            {
              name = "fzf-tab";
              source = pkgs.zsh-plugins.fzf-tab;
              config = "";
            }
            {
              name = "fast-syntax-highlighting";
              source = pkgs.zsh-plugins.fast-syntax-highlighting;
            }
          ];
        };
        theme = "powerlevel10k/powerlevel10k";
        plugins = [ "sudo" "git" "fzf" "zoxide" "cp" ]
          ++ lib.optionals pkgs.stdenv.isDarwin [ "brew" "macos" ]
          ++ lib.optionals pkgs.stdenv.isLinux [ ];
      };
      initExtraFirst = ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';
      initExtra = ''
        export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
        export ZSH_TAB_TITLE_ONLY_FOLDER=true
        export ZSH_TAB_TITLE_ADDITIONAL_TERMS='iterm|kitty'
        zstyle ":completion:*:git-checkout:*" sort false
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      '';
      shellAliases = with pkgs;
        let
          ezaTree = lib.listToAttrs (map (i: {
            name = "ls${toString i}";
            value = "ls -T --level=${toString i}";
          }) (lib.range 0 10));
          ezaTreelist = lib.listToAttrs (map (i: {
            name = "l${toString i}";
            value = "ls -T --level=${toString i} -l";
          }) (lib.range 0 10));
        in {
          "nix-shell" = "nix-shell --run zsh";
          gnox = "go run -C ~/go/src/github.com/gnolang/gno ./gnovm/cmd/gno";
          gnokeyx =
            "go run -C ~/go/src/github.com/gnolang/gno ./gno.land/cmd/gnokey";
          gnodevx =
            "go run -C ~/go/src/github.com/gnolang/gno/contribs/gnodev .";
          gnolandx =
            "go run -C ~/go/src/github.com/gnolang/gno ./gno.land/cmd/gnoland";
          dev = "(){ nix develop $1 -c $SHELL ;}";
          mydev = "(){ nix develop my#$1 -c $SHELL ;}";
          kssh = "${pkgs.pkgs-stable.kitty}/bin/kitten ssh";
          ".." = "cd ..";
          cat = "${bat}/bin/bat";
          du = "${du-dust}/bin/dust";
          pp = "${homeDirectory}/go/bin/pp";
          rg =
            "${ripgrep}/bin/rg --column --line-number --no-heading --color=always --ignore-case";
          ls = "${eza}/bin/eza";
          l = "ls -l --icons";
          la = "l -a";
          ll = "ls -lhmbgUFH --git --icons";
          lla = "ll -a";
          config = "make -C ${homeDirectory}/nixpkgs";
        } // ezaTree // ezaTreelist
        // (lib.optionalAttrs (stdenv.system == "aarch64-darwin") {
          rosetta-zsh = "${pkgs-x86.zsh}/bin/zsh";
        });
    };
  }

  # === tmux.nix ===
  {
    programs.tmux = {
      enable = true;
      terminal = "screen-256color";
      keyMode = "emacs";
      shell = "${pkgs.zsh}/bin/zsh";
      escapeTime = 20;
      clock24 = true;
      baseIndex = 1;
      plugins = with pkgs; [
        tmuxPlugins.copycat
        tmuxPlugins.resurrect
        tmuxPlugins.sensible
        tmuxPlugins.prefix-highlight
        tmuxPlugins.yank
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60'
          '';
        }
      ];
      extraConfig = ''
        set -g default-command "${pkgs.zsh}/bin/zsh"
        bind-key -n C-S-Left swap-window -t -1
        bind-key -n C-S-Right swap-window -t +1
        set -g visual-activity off
        set -g visual-bell off
        set -g visual-silence off
        setw -g monitor-activity off
        set -g bell-action none
        setw -g clock-mode-colour colour5
        setw -g mode-style 'fg=colour1 bg=colour18 bold'
        set -g pane-border-style 'fg=colour9 bg=colour0'
        set -g pane-active-border-style 'bg=colour5 fg=colour9'
        set -g display-panes-time 3000
        set -g status-position bottom
        set -g status-justify left
        set -g status-style 'bg=colour16 fg=colour137 dim'
        set -g status-interval 5
        setw -g window-status-current-style 'fg=colour1 bg=colour21 bold'
        setw -g window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '
        setw -g window-status-style 'fg=colour9 bg=colour18'
        setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
        setw -g window-status-bell-style 'fg=colour255 bg=colour1 bold'
        set -g status-left " #[fg=colour9]#S "
        set -g status-left-length 100
        set -g status-right-length 100
        set -g status-right '#{prefix_highlight} #[fg=colour1,bg=colour18,nobold,nounderscore,noitalics]#[fg=colour121,bg=colour18] %l:%M %p  %d %b %Y  #[fg=colour1,bg=colour18,nobold,nounderscore,noitalics]#[fg=colour1,bg=colour21,bold] #H #[fg=colour1,bg=colour21,nobold,nounderscore,noitalics]#[fg=colour21,bg=colour1]  #(rainbarf --battery --remaining --no-rgb) '
        set -g message-style 'fg=colour232 bg=colour6 bold'
        set -g mouse off
        set-option -g allow-rename off
      '';
    };
  }
]
