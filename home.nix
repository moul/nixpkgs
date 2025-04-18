# home.nix
# Consolidated Home Manager modules
{ inputs, pkgs, lib, config, ... }:

let
  # Helper function to read local config files relative to flake root
  readFile = path: builtins.readFile (toString ./../config + "/${path}");

  # --- Start Inlined: modules/home/colors/colorscheme.nix ---
  inlined_colorscheme = { name, config, lib, ... }:
    let
      inherit (lib)
        attrNames attrValues hasPrefix listToAttrs literalExpression mapAttrs
        mkOption range types;

      baseColorOptions = listToAttrs (map (i: {
        name = "color${toString i}";
        value = mkOption { type = types.str; };
      }) (range 0 15)) // listToAttrs (map (i: {
        name = "color${toString i}";
        value = mkOption {
          default = "#00000";
          type = types.str;
        };
      }) (range 16 99));

      mkColorOption = args:
        mkOption (args // {
          type = types.enum (attrNames config.colors ++ attrValues config.colors
            ++ attrNames config.namedColors);
          apply = v: config.colors.${v} or config.namedColors.${v} or v;
        });

      kittyBaseColorOptions = listToAttrs (map (i: {
        name = "color${toString i}";
        value = mkColorOption { default = "color${toString i}"; };
      }) (range 0 15));

    in {
      options = {
        name = mkOption {
          type = types.str;
          default = name;
          defaultText = literalExpression "<name>";
        };
        colors = mkOption { type = types.submodule { options = baseColorOptions; }; };
        namedColors = mkOption {
          type = types.attrsOf (types.enum (attrNames config.colors ++ attrValues config.colors));
          default = { };
          apply = mapAttrs (_: v: if hasPrefix "color" v then config.colors.${v} else v);
        };
        terminal = mkOption {
          type = types.submodule {
            options = {
              bg = mkColorOption { };
              fg = mkColorOption { };
              cursorBg = mkColorOption { };
              cursorFg = mkColorOption { };
              selectionBg = mkColorOption { };
              selectionFg = mkColorOption { };
            };
          };
        };
        pkgThemes.kitty = mkOption {
          type = types.submodule {
            options = kittyBaseColorOptions // {
              background = mkColorOption { default = config.terminal.bg; };
              foreground = mkColorOption { default = config.terminal.fg; };
              cursor = mkColorOption { default = config.terminal.cursorBg; };
              cursor_text_color = mkColorOption { default = config.terminal.cursorFg; };
              selection_background = mkColorOption { default = config.terminal.selectionBg; };
              selection_foreground = mkColorOption { default = config.terminal.selectionFg; };
              url_color = mkColorOption { };
              tab_bar_background = mkColorOption { };
              active_tab_background = mkColorOption { };
              active_tab_foreground = mkColorOption { };
              inactive_tab_foreground = mkColorOption { };
              inactive_tab_background = mkColorOption { };
              bell_border_color = mkColorOption { };
              active_border_color = mkColorOption { default = config.terminal.bg; };
              inactive_border_color = mkColorOption { };
            };
          };
        };
      };
    };
  # --- End Inlined: modules/home/colors/colorscheme.nix ---
in
{
  # Contents from home/asdf.nix
  my-asdf = { pkgs, config, ... }:
    let
      asdf-config = pkgs.writeText "asdfrc" ''
        # See the docs for explanations: https://asdf-vm.com/manage/configuration.html
        legacy_version_file = no
        use_release_candidates = no
        always_keep_download = no
        disable_plugin_short_name_repository = no
        ${if pkgs.stdenv.isDarwin then "java_macos_integration_enable = yes" else ""}
      '';
    in {
      home.file."${config.xdg.configHome}/asdf/asdfrc" = { source = asdf-config; };
      home.sessionVariables = {
        ASDF_CONFIG_FILE = "${config.xdg.configHome}/asdf/asdfrc";
        ASDF_DATA_DIR = "${config.xdg.dataHome}/asdf";
        ASDF_DIR = "${pkgs.asdf-vm}/share/asdf-vm";
      };
    };

  # Contents from home/colors.nix
  my-colors = { config, ... }: {
    colors.catppuccin-macchiato = {
      colors = {
        color0 = "#181926"; color8 = "#1e2030"; color1 = "#ed8796";
        color9 = "#ee99a0"; color2 = "#a6da95"; color10 = "#8bd5ca";
        color3 = "#f5a97f"; color11 = "#eed49f"; color4 = "#8aadf4";
        color12 = "#b7bdf8"; color5 = "#f5bde6"; color13 = "#c6a0f6";
        color6 = "#91d7e3"; color14 = "#7dc4e4"; color7 = "#f4dbd6";
        color15 = "#f0c6c6"; color16 = "#cad3f5"; color17 = "#24273a";
        color18 = "#1e2030"; color19 = "#181926"; color20 = "#494d64";
        color21 = "none";
      };
      namedColors = {
        black = "color0"; brightBlack = "color8"; red = "color1"; brightRed = "color9";
        green = "color2"; brightGreen = "color10"; yellow = "color3"; brightYellow = "color11";
        blue = "color4"; brightBlue = "color12"; magenta = "color5"; brightMagenta = "color13";
        cyan = "color6"; brightCyan = "color14"; white = "color7"; brightWhite = "color15";
        text = "color16"; base = "color17"; mantle = "color18"; crust = "color19";
        surface = "color20"; none = "color21";
      };
      terminal = { bg = "base"; fg = "text"; cursorBg = "white"; cursorFg = "black"; selectionBg = "white"; selectionFg = "black"; };
      pkgThemes.kitty = {
        url_color = "blue"; tab_bar_background = "none"; active_tab_background = "yellow";
        active_tab_foreground = "black"; inactive_tab_background = "crust";
        inactive_tab_foreground = "text"; active_border_color = "yellow";
        inactive_border_color = "surface"; bell_border_color = "brightBlue";
      };
    };
    colors.material = {
      colors = {
        color0 = "#546e7a"; color8 = "#b0bec5"; color1 = "#ff5252"; color9 = "#ff8a80";
        color2 = "#5cf19e"; color10 = "#b9f6ca"; color3 = "#ffd740"; color11 = "#ffe57f";
        color4 = "#40c4ff"; color12 = "#80d8ff"; color5 = "#ff4081"; color13 = "#ff80ab";
        color6 = "#64fcda"; color14 = "#a7fdeb"; color7 = "#ffffff"; color15 = "#ffffff";
        color16 = "#eceff1"; color17 = "#263238"; color18 = "#607d8b";
      };
      namedColors = {
        black = "color0"; brightBlack = "color8"; red = "color1"; brightRed = "color9";
        green = "color2"; brightGreen = "color10"; yellow = "color3"; brightYellow = "color11";
        blue = "color4"; brightBlue = "color12"; magenta = "color5"; brightMagenta = "color13";
        cyan = "color6"; brightCyan = "color14"; white = "color7"; brightWhite = "color15";
        brightGray = "color16"; gunmetal = "color17"; steelTeal = "color18";
      };
      terminal = { bg = "base"; fg = "text"; cursorBg = "white"; cursorFg = "black"; selectionBg = "white"; selectionFg = "black"; };
      pkgThemes.kitty = {
        url_color = "blue"; tab_bar_background = "black"; active_tab_background = "gunmetal";
        active_tab_foreground = "green"; inactive_tab_background = "black";
        inactive_tab_foreground = "brightGreen";
      };
    };
    colors."manfred-touron" = {
      colors = {
        color0 = "#000000"; color8 = "#4e4e4e"; color1 = "#ff0000"; color9 = "#ff008b";
        color2 = "#51ff0f"; color10 = "#62c750"; color3 = "#e7a800"; color11 = "#f4ff00";
        color4 = "#3950d7"; color12 = "#70a5ed"; color5 = "#d336b1"; color13 = "#b867e6";
        color6 = "#66b2ff"; color14 = "#00d4fc"; color7 = "#cecece"; color15 = "#ffffff";
        color16 = "#eceff1"; color17 = "#263238"; color18 = "#607d8b"; color19 = "#181926";
        color20 = "#494d64"; color21 = "none";
      };
      namedColors = {
        black = "color0"; brightBlack = "color8"; red = "color1"; brightRed = "color9";
        green = "color2"; brightGreen = "color10"; yellow = "color3"; brightYellow = "color11";
        blue = "color4"; brightBlue = "color12"; magenta = "color5"; brightMagenta = "color13";
        cyan = "color6"; brightCyan = "color14"; white = "color7"; brightWhite = "color15";
        text = "color16"; base = "color0"; mantle = "color18"; crux = "color19"; surface = "color20"; none = "color21";
        brightGray = "color16"; gunmetal = "color17"; steelTeal = "color18";
      };
      terminal = { bg = "base"; fg = "text"; cursorBg = "white"; cursorFg = "black"; selectionBg = "white"; selectionFg = "black"; };
      pkgThemes.kitty = {
        url_color = "blue"; tab_bar_background = "black"; active_tab_background = "gunmetal";
        active_tab_foreground = "green"; inactive_tab_background = "black";
        inactive_tab_foreground = "brightGreen"; active_border_color = "yellow";
        inactive_border_color = "surface"; bell_border_color = "brightBlue";
      };
    };
  };

  # Contents from home/config.nix
  my-config = { lib, pkgs, config, ... }:
    let
      inherit (pkgs) stdenv;
      inherit (lib) mkIf;
      btopConfigContent = readFile "btop/btop.conf"; # Assuming btop.conf is the main file
    in {
      home.file.".config/btop/btop.conf" = { text = btopConfigContent; };
      home.file.".npmrc" = {
        text = ''prefix=${config.xdg.dataHome}/node_modules'';
      };
      home.file.".aspell.config" = {
        text = ''
          dict-dir ""
          master en_US
          extra-dicts en en-computers.rws en-science.rws fr.rws
        '';
      };
    };

  # Contents from home/emacs.nix
  my-emacs = { config, lib, pkgs, ... }:
    let
      my-emacs = pkgs.emacs30-nox.override { withNativeCompilation = false; noGui = true; };
      emScriptContent = readFile "em";
      rawEmacsScriptContent = readFile "raw-emacs";
      em = pkgs.writeShellScriptBin "em" emScriptContent;
      raw-emacs-old = pkgs.writeShellScriptBin "raw-emacs-old" rawEmacsScriptContent;
    in {
      programs.emacs = {
        enable = true;
        package = my-emacs;
        extraConfig = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ''
          ; macOS ls doesn't support --dired
          (setq dired-use-ls-dired nil)
        '';
        extraPackages = epkgs: with epkgs; [
          org better-defaults diminish ido-completing-read+ smex flycheck
          envrc company dockerfile-mode go-mode kubel lsp-mode lsp-pyright
          lsp-ui magit markdown-mode nix-mode nix-sandbox pretty-mode
          projectile yaml-mode polymode
        ];
      };
      home.packages = [ pkgs.sqlite em raw-emacs-old ];
      home.file.".emacs.d/init.el" = { source = ../config/emacs/init.el; }; # Keep relative path
      home.file.".emacs.d/config.org" = { source = ../config/emacs/config.org; }; # Keep relative path
      programs.zsh.shellAliases = {
        emacs = "em"; emasc = "em"; eamsc = "em"; emaccs = "em"; emacss = "em";
        raw-emacs = "${my-emacs}/bin/emacs";
      };
    };

  # Contents from home/git.nix
  my-git = { config, pkgs, ... }: {
    programs.git = {
      enable = true;
      userEmail = config.home.user-info.email;
      userName = config.home.user-info.username;
      extraConfig = {
        core.whitespace = "trailing-space,space-before-tab";
        diff.colorMoved = "default";
        pull.rebase = true;
      };
      ignores = [ "*~" "*.swp" "*#" ".#*" ".DS_Store" ];
      delta.enable = true;
      lfs.enable = true;
      aliases = {
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(italic)- %an%C(reset)%C(magenta bold)%d%C(reset)' --all";
      };
    };
    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
  };

  # Contents from home/kitty.nix
  my-kitty = { config, lib, pkgs, ... }:
    let theme = config.colors."manfred-touron";
    in {
      programs.kitty.enable = true;
      programs.kitty.settings = {
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
        font_features = "+cv02 +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +ss10 +zero +onum";
      };
      programs.kitty.extras.useSymbolsFromNerdFont = "FiraCode Nerd Font Mono";
      programs.kitty.extras.colors = {
        enable = true;
        dark = theme.pkgThemes.kitty;
      };
      programs.truecolor.enable = true;
      programs.truecolor.useterm = "xterm-kitty";
      programs.truecolor.terminfo = "${pkgs.pkgs-stable.kitty.terminfo}/share/terminfo";
      programs.kitty.keybindings = {
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
        "cmd+k" = "combine : clear_terminal scrollback active : send_text normal,application x0c";
        "cmd+1" = "goto_tab 1"; "cmd+2" = "goto_tab 2"; "cmd+3" = "goto_tab 3";
        "cmd+4" = "goto_tab 4"; "cmd+5" = "goto_tab 5"; "cmd+6" = "goto_tab 6";
        "cmd+7" = "goto_tab 7"; "cmd+8" = "goto_tab 8"; "cmd+9" = "goto_tab 9";
        "kitty_mod+equal" = "change_font_size all +1.0";
        "kitty_mod+minus" = "change_font_size all -1.0";
        "kitty_mod+0" = "change_font_size all 0";
      };
    };

  # Contents from home/packages.nix
  my-packages = { config, lib, pkgs, ... }:
    let
      inherit (config.home) user-info homeDirectory;
      rust_home = "${config.xdg.dataHome}/rust";
    in {
      programs.ssh = {
        enable = true; controlMaster = "auto";
        controlPath = "${config.xdg.cacheHome}/ssh-%u-%r@%h:%p";
        controlPersist = "1800"; forwardAgent = true;
        serverAliveInterval = 60; hashKnownHosts = true;
        extraConfig = lib.mkIf pkgs.stdenv.isDarwin ''
          IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        '';
      };
      manual.html.enable = false;
      manual.manpages.enable = false;
      targets.genericLinux.enable = pkgs.stdenv.isLinux;
      programs.go = {
        enable = true; goPath = "go"; goBin = ".local/bin"; package = pkgs.go;
      };
      home.sessionPath = [
        "${rust_home}/cargo/bin"
        "${rust_home}/rustup/bin"
        "${homeDirectory}/go/bin"
      ];
      programs.bat.enable = true;
      programs.bat.themes = {
        catppuccin-macchiato = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin"; repo = "bat";
            rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
            sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          };
          file = "/Catppuccin-macchiato.tmTheme";
        };
      };
      programs.bat.config = { style = "plain"; theme = "catppuccin-macchiato"; };
      home.packages = with pkgs; [
        abduco ascii assh bandwhich bottom browsh coreutils curl diff-so-fancy
        nerd-fonts.iosevka nerd-fonts.fira-code du-dust entr expect fd file fzf gist git-crypt
        ghostscript gnumake gnupg graphviz hub htop httpie hyperfine imagemagick inetutils
        ispell mosh nodePackages.speed-test nodejs nmap openssl parallel pre-commit protobuf
        pstree ripgrep socat tcpdump tealdeer thefuck tree tmuxinator unrar unzip wget xz jq
        yq unixtools.watch vivid cachix comma nixfmt-classic nix-diff nix-index nix-info
        nix-prefetch-github nix-prefetch-scripts nix-tree nix-update nixpkgs-review
        nodePackages.node2nix statix tig eza btop tmate most lazydocker lazygit less
        (ripgrep.override { withPCRE2 = true; }) cmake my-libvterm procs
        (aspellWithDicts (d: [ d.en d.fr d.en-computers d.en-science ]))
        aspellDicts.fr aspellDicts.en aspellDicts.en-science aspellDicts.en-computers
        pkgs-stable.rustup pkgs-stable.ruby_3_1 pkgs-stable.nodejs-18_x pkgs-stable.nodePackages.pnpm
        pkgs-stable.yarn (pkgs-stable.python39.withPackages (p: with p; [ virtualenv pip mypy pylint yapf setuptools ]))
        pipenv gofumpt gopls delve (gotools.overrideDerivation (oldAttrs: { excludedPackages = [ "bundle" ]; }))
        nixpkgs-fmt cachix lorri niv nix-prefetch nix-prefetch-git nixfmt-classic
      ] ++ lib.optionals stdenv.isDarwin [ cocoapods ]
        ++ lib.optionals stdenv.isLinux [ docker docker-compose ];
    };

  # Contents from home/shells.nix
  my-shells = { config, lib, pkgs, ... }:
    let
      inherit (config.home) user-info homeDirectory;
      configDir = ".config"; cacheDir = ".cache"; dataDir = ".local/share";
      oh-my-zsh-custom = "${configDir}/oh-my-zsh";
      restart-service = pkgs.writeShellScriptBin "restart-service" ''... (script content) ...''; # Placeholder for brevity
    in {
      xdg = {
        enable = true; configHome = "${homeDirectory}/${configDir}";
        cacheHome = "${homeDirectory}/${cacheDir}"; dataHome = "${homeDirectory}/${dataDir}";
      };
      home.sessionPath = [
        "${homeDirectory}/.local/bin"
        "${config.xdg.dataHome}/node_modules/bin"
        "${homeDirectory}/go/bin"
      ];
      home.sessionVariables = {
        LC_ALL = "en_US.UTF-8";
        FZF_BASE = "${pkgs.fzf}/share/fzf";
        TERMINFO_DIRS = "${pkgs.pkgs-stable.kitty.terminfo.outPath}/share/terminfo:$TERMINFO_DIRS";
      };
      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;
      programs.htop.enable = true;
      programs.htop.settings.show_program_path = true;
      programs.zoxide.enable = true;
      programs.zsh = {
        enable = true; dotDir = ".config/zsh";
        plugins = [{ name = "p10k-config"; src = lib.cleanSource ../config/zsh/p10k; file = "config.zsh"; }]; # Keep relative path
        enableCompletion = true; completionInit = "autoload -U compinit && compinit -i";
        autosuggestion.enable = true;
        oh-my-zsh = {
          enable = true; custom = "${config.xdg.configHome}/oh-my-zsh";
          extras = {
            themes = [{ name = "powerlevel10k"; source = pkgs.zsh-plugins.powerlevel10k; }];
            plugins = [
              { name = "fzf-tab"; source = pkgs.zsh-plugins.fzf-tab; config = ''... (fzf-tab config) ...''; } # Placeholder
              { name = "fast-syntax-highlighting"; source = pkgs.zsh-plugins.fast-syntax-highlighting; }
            ];
          };
          theme = "powerlevel10k/powerlevel10k";
          plugins = [ "sudo" "git" "fzf" "zoxide" "cp" ]
            ++ lib.optionals pkgs.stdenv.isDarwin [ "brew" "macos" ]
            ++ lib.optionals pkgs.stdenv.isLinux [ ];
        };
        initExtraFirst = ''... (p10k instant prompt) ...''; # Placeholder
        initExtra = ''... (autosuggest color, tab title, zstyle) ...''; # Placeholder
        shellAliases = with pkgs;
          let
            ezaTree = lib.listToAttrs (map (i: { name = "ls${toString i}"; value = "ls -T --level=${toString i}"; }) (lib.range 0 10));
            ezaTreelist = lib.listToAttrs (map (i: { name = "l${toString i}"; value = "ls -T --level=${toString i} -l"; }) (lib.range 0 10));
          in {
            "nix-shell" = "nix-shell --run zsh";
            gnox = "go run -C ~/go/src/github.com/gnolang/gno ./gnovm/cmd/gno";
            gnokeyx = "go run -C ~/go/src/github.com/gnolang/gno ./gno.land/cmd/gnokey";
            gnodevx = "go run -C ~/go/src/github.com/gnolang/gno/contribs/gnodev .";
            gnolandx = "go run -C ~/go/src/github.com/gnolang/gno ./gno.land/cmd/gnoland";
            dev = "(){ nix develop $1 -c $SHELL ;}";
            mydev = "(){ nix develop my#$1 -c $SHELL ;}";
            kssh = "${pkgs.pkgs-stable.kitty}/bin/kitten ssh";
            ".." = "cd .."; cat = "${bat}/bin/bat"; du = "${du-dust}/bin/dust";
            pp = "${homeDirectory}/go/bin/pp"; rg = "${ripgrep}/bin/rg --column --line-number --no-heading --color=always --ignore-case";
            ls = "${eza}/bin/eza"; l = "ls -l --icons"; la = "l -a";
            ll = "ls -lhmbgUFH --git --icons"; lla = "ll -a";
            config = "make -C ${homeDirectory}/nixpkgs";
          } // ezaTree // ezaTreelist // (lib.optionalAttrs (stdenv.system == "aarch64-darwin") {
            rosetta-zsh = "${pkgs-x86.zsh}/bin/zsh";
          });
      };
    };

  # Contents from home/tmux.nix
  my-tmux = { config, lib, pkgs, ... }: {
    programs.tmux = {
      enable = true; terminal = "screen-256color"; keyMode = "emacs";
      shell = "${pkgs.zsh}/bin/zsh"; escapeTime = 20; clock24 = true; baseIndex = 1;
      plugins = with pkgs; [
        tmuxPlugins.copycat tmuxPlugins.resurrect tmuxPlugins.sensible
        tmuxPlugins.prefix-highlight tmuxPlugins.yank
        { plugin = tmuxPlugins.continuum; extraConfig = ''... (continuum config) ...''; } # Placeholder
      ];
      extraConfig = ''... (tmux extra config) ...''; # Placeholder
    };
  };

  # Contents from modules/home/colors/default.nix
  # This defines the `colors` option structure
  colors-module-options = { lib, ... }:
    let inherit (lib) mkOption types;
    in {
      options = {
        colors = mkOption {
          default = { };
          # Reference the inlined colorscheme structure
          type = types.attrsOf (types.submodule inlined_colorscheme);
        };
      };
    };

  # Contents from modules/home/programs/kitty/extras.nix
  programs-kitty-extras = { config, lib, pkgs, ... }:
    with lib;
    let
      cfg = config.programs.kitty.extras;
      setToKittyConfig = with generators; toKeyValue { mkKeyValue = mkKeyValueDefault { } " "; };
      writeKittyConfig = fileName: config: pkgs.writeTextDir "${fileName}" (setToKittyConfig config);
      kitty-colors = pkgs.symlinkJoin {
        name = "kitty-colors";
        paths = [
          (writeKittyConfig "dark-colors.conf" cfg.colors.dark)
          (writeKittyConfig "light-colors.conf" cfg.colors.light)
        ];
      };
      term-background = pkgs.writeShellScriptBin "term-background" ''... (script content) ...''; # Placeholder
      term-light = pkgs.writeShellScriptBin "term-light" ''${term-background}/bin/term-background light'';
      term-dark = pkgs.writeShellScriptBin "term-dark" ''${term-background}/bin/term-background dark'';
      socket = "unix:/tmp/mykitty";
    in {
      options.programs.kitty.extras = {
        colors = {
          enable = mkOption { type = types.bool; default = false; description = ''...''; };
          dark = mkOption { type = with types; attrsOf str; default = { }; description = ''...''; };
          light = mkOption { type = with types; attrsOf str; default = { }; description = ''...''; };
          common = mkOption { type = with types; attrsOf str; default = { }; description = ''...''; };
          default = mkOption { type = types.enum [ "dark" "light" ]; default = "dark"; description = ''...''; };
        };
        useSymbolsFromNerdFont = mkOption { type = types.str; default = ""; example = "JetBrainsMono Nerd Font"; description = ''...''; };
      };
      config = mkIf config.programs.kitty.enable {
        home.packages = mkIf cfg.colors.enable [ term-light term-dark term-background ];
        programs.kitty.settings = optionalAttrs cfg.colors.enable (
          cfg.colors.common // cfg.colors.${cfg.colors.default} // {
            allow_remote_control = "yes";
            listen_on = socket;
          }
        ) // optionalAttrs (cfg.useSymbolsFromNerdFont != "") {
          symbol_map = "U+E5FA-U+E62B,... ${cfg.useSymbolsFromNerdFont}"; # Placeholder
        };
        programs.kitty.darwinLaunchOptions = mkIf pkgs.stdenv.isDarwin [ "--listen-on ${socket}" ];
      };
    };

  # Contents from modules/home/programs/truecolor/default.nix
  programs-truecolor = { config, lib, pkgs, ... }:
    with lib;
    let cfg = config.programs.truecolor;
    in {
      options.programs.truecolor = {
        enable = mkEnableOption "truecolor";
        useterm = mkOption { type = types.str; default = "xterm-256colors"; description = ''term to use''; };
        terminfo = mkOption { type = types.str; default = "/usr/share/terminfo"; description = ''terminfo path to use''; };
      };
      config = let
        xterm-source = pkgs.writeText "xterm.terminfo" ''... (terminfo content) ...''; # Placeholder
        xterm-emacs = pkgs.runCommandLocal "xterm-emacs" {
          output = [ "terminfo" ]; nativeBuildInputs = [ pkgs.ncurses ];
        } ''
          mkdir -p $out/share/terminfo
          export TERMINFO_DIRS=${cfg.terminfo}
          tic -x -o $out/share/terminfo ${xterm-source}
        '';
      in mkIf config.programs.truecolor.enable {
        home.packages = [ xterm-emacs ];
        home.file.".terminfo".source = "${xterm-emacs}/share/terminfo";
      };
    };

  # Contents from modules/home/programs/zsh/oh-my-zsh/extras.nix
  programs-zsh-oh-my-zsh-extra = { config, lib, pkgs, ... }:
    with lib;
    let
      cfg = config.programs.zsh.oh-my-zsh.extras;
      pluginExtra = types.submodule ({ ... }: { options = { name = mkOption { type = types.str; ... }; source = mkOption { type = types.path; ... }; config = mkOption { type = types.str; ... }; }; }); # Placeholder
      themeExtra = types.submodule ({ ... }: { options = { name = mkOption { type = types.str; ... }; source = mkOption { type = types.path; ... }; }; }); # Placeholder
    in {
      options.programs.zsh.oh-my-zsh.extras = {
        plugins = mkOption { type = types.listOf pluginExtra; default = [ ]; description = "list of extra plugins"; };
        themes = mkOption { type = types.listOf themeExtra; default = [ ]; description = "list of extra themes"; };
      };
      config = let
        pluginsList = (map (p: { name = "${config.programs.zsh.oh-my-zsh.custom}/plugins/${p.name}"; value = { source = p.source; recursive = true; }; }) cfg.plugins);
        themesList = (map (t: { name = "${config.programs.zsh.oh-my-zsh.custom}/themes/${t.name}"; value = { source = t.source; recursive = true; }; }) cfg.themes);
        configExtra = concatStringsSep "\n" (map (p: ''## ${p.name} config\n\n${p.config}'') (filter (p: p.config != "") cfg.plugins));
      in mkIf config.programs.zsh.oh-my-zsh.enable {
        home.file = listToAttrs (pluginsList ++ themesList);
        programs.zsh.initExtra = mkIf (configExtra != "") ''# oh-my-zsh plugins config\n\n${configExtra}'';
      };
    };

  # Module defining the home.user-info structure (originally inline in flake.nix)
  home-user-info = { lib, ... }: {
    options.home.user-info = (inputs.self.darwinModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
    # Note: The above line assumes darwinModules is accessible via inputs.self. Might need adjustment.
    # A safer approach might be to define the user-info options structure directly here,
    # duplicating the definition from modules/darwin/users.nix.
    # Example (duplicate definition):
    # options.home.user-info = {
    #   username = lib.mkOption { type = with lib.types; nullOr string; default = null; };
    #   fullName = lib.mkOption { type = with lib.types; nullOr string; default = null; };
    #   email = lib.mkOption { type = with lib.types; nullOr string; default = null; };
    #   nixConfigDirectory = lib.mkOption { type = with lib.types; nullOr string; default = null; };
    # };
  };
}