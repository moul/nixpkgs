{
  inputs = {
    # Package semodules
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # flake utils
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    flake-utils.url = "github:numtide/flake-utils";

    # lsp
    #rnix-lsp.url = "github:nix-community/rnix-lsp";

    # overlay
    home-manager.url = "github:nix-community/home-manager/master";
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    # Other sources

    # emacs
    spacemacs.url = "github:syl20bnr/spacemacs/develop";
    spacemacs.flake = false;

    doomemacs.url = "github:doomemacs/doomemacs/master";
    doomemacs.flake = false;

    chemacs2.url = "github:plexus/chemacs2/main";
    chemacs2.flake = false;

    # zsh plugins
    fast-syntax-highlighting.url =
      "github:zdharma-continuum/fast-syntax-highlighting";
    fast-syntax-highlighting.flake = false;

    fzf-tab.url = "github:Aloxaf/fzf-tab";
    fzf-tab.flake = false;

    powerlevel10k.url = "github:romkatv/powerlevel10k";
    powerlevel10k.flake = false;
  };

  outputs = { self, darwin, home-manager, flake-utils
    , lib ? inputs.nixpkgs-unstable.lib, pkgs ? inputs.nixpkgs-unstable, ...
    }@inputs:
    let
      flakeRoot = ./.;
      inherit (lib)
        attrValues makeOverridable optionalAttrs singleton
        removeAttrs; # Use lib from inputs directly here

      homeStateVersion = "23.05";

      # Configuration for `nixpkgs`
      nixpkgsDefaults = {
        config = { allowUnfree = true; };
        overlays = attrValues self.overlays ++ [
          # put stuff here
        ];
      };

      primaryUserInfo = {
        username = "moul";
        fullName = "";
        email = "94029+moul@users.noreply.github.com";
        nixConfigDirectory = "/Users/moul/nixpkgs";
      };

      ciUserInfo = {
        username = "runner";
        fullName = "";
        email = "github-actions@github.com";
        nixConfigDirectory = "/Users/runner/work/nixpkgs/nixpkgs";
      };

      # --- Helper Functions ---
      readFile = path: builtins.readFile "${flakeRoot}/config/${path}";

      mkColorschemeOptions =
        { name, config, lib, ... }: # Takes args from submodule mechanism
        let
          inherit (lib)
            attrNames attrValues hasPrefix listToAttrs literalExpression
            mapAttrs mkOption range types;

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
              type = types.enum (attrNames config.colors
                ++ attrValues config.colors ++ attrNames config.namedColors);
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
            colors = mkOption {
              type = types.submodule { options = baseColorOptions; };
            };
            namedColors = mkOption {
              type = types.attrsOf (types.enum
                (attrNames config.colors ++ attrValues config.colors));
              default = { };
              apply = mapAttrs
                (_: v: if hasPrefix "color" v then config.colors.${v} else v);
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
                  cursor =
                    mkColorOption { default = config.terminal.cursorBg; };
                  cursor_text_color =
                    mkColorOption { default = config.terminal.cursorFg; };
                  selection_background =
                    mkColorOption { default = config.terminal.selectionBg; };
                  selection_foreground =
                    mkColorOption { default = config.terminal.selectionFg; };
                  url_color = mkColorOption { };
                  tab_bar_background = mkColorOption { };
                  active_tab_background = mkColorOption { };
                  active_tab_foreground = mkColorOption { };
                  inactive_tab_foreground = mkColorOption { };
                  inactive_tab_background = mkColorOption { };
                  bell_border_color = mkColorOption { };
                  active_border_color =
                    mkColorOption { default = config.terminal.bg; };
                  inactive_border_color = mkColorOption { };
                };
              };
            };
          };
        };
      # --- End Helper ---

      # --- Inlined Darwin Modules ---
      darwinModulesAttrs = {
        # Contents from darwin/bootstrap.nix
        my-bootstrap = { config, lib, pkgs, ... }: {
          nix.settings = {
            substituters = [
              "https://cache.nixos.org/"
              "https://nix-community.cachix.org"
              "https://gfanton.cachix.org"
              "https://moul.cachix.org"
              "https://moul2.cachix.org"
            ];
            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "gfanton.cachix.org-1:i8zC+UjhhW5Wx2iRibhexJeBb1jOU/8oRFGG60IaAmI="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "moul.cachix.org-1:jcmTECmIfe9zam+p4sP3RhEXmH7QTTChd9ax/vo1CYs="
              "moul2.cachix.org-1:Skk3CKj8duDH5yH+8k8msB/OELtftqdIqH1b6YuWe94="
            ];
            trusted-users = [ "@admin" ];
            auto-optimise-store = false;
            experimental-features = [ "nix-command" "flakes" ];
            keep-outputs = true;
            keep-derivations = true;
            extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
              "x86_64-darwin"
              "aarch64-darwin"
            ];
          };
          environment.shells = with pkgs; [ bashInteractive zsh ];
          programs.zsh.enable = true;
          environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";
          environment.extraInit = ''export PATH="$HOME/bin:$PATH"'';
          system.stateVersion = 5;
        };

        # Contents from darwin/defaults.nix
        my-defaults = { lib, config, ... }: { # Removed unused pkgs
          system.defaults.NSGlobalDomain = {
            "com.apple.trackpad.scaling" = 3.0;
            AppleInterfaceStyleSwitchesAutomatically = false;
            AppleInterfaceStyle = "Dark";
            AppleMeasurementUnits = "Centimeters";
            ApplePressAndHoldEnabled = true;
            AppleMetricUnits = 1;
            AppleShowScrollBars = "Automatic";
            AppleTemperatureUnit = "Celsius";
            InitialKeyRepeat = 15;
            KeyRepeat = 1;
            NSAutomaticCapitalizationEnabled = false;
            NSAutomaticDashSubstitutionEnabled = false;
            NSAutomaticPeriodSubstitutionEnabled = false;
            NSWindowResizeTime = 1.0e-2;
            _HIHideMenuBar = false;
            "com.apple.sound.beep.feedback" = 0;
            "com.apple.sound.beep.volume" = 0.0;
            AppleKeyboardUIMode = 3;
            AppleShowAllExtensions = true;
            NSAutomaticWindowAnimationsEnabled = false;
          };
          system.defaults.CustomSystemPreferences = {
            NSGlobalDomain = { NSWindowShouldDragOnGesture = true; };
          };
          system.defaults.alf = {
            globalstate = 1;
            allowsignedenabled = 1;
            allowdownloadsignedenabled = 1;
            stealthenabled = 1;
          };
          system.defaults.dock = {
            autohide = true;
            expose-group-apps = false;
            mru-spaces = false;
            tilesize = 25;
            show-recents = true;
            wvous-bl-corner = 1;
            wvous-br-corner = 1;
            wvous-tl-corner = 1;
            wvous-tr-corner = 1;
            launchanim = false;
            autohide-delay = 0.1;
            autohide-time-modifier = 0.1;
            expose-animation-duration = 0.1;
          };
          system.defaults.loginwindow = {
            GuestEnabled = false;
            DisableConsoleAccess = true;
          };
          system.defaults.spaces.spans-displays = false;
          system.defaults.trackpad = {
            Clicking = false;
            TrackpadRightClick = true;
          };
          system.defaults.finder = {
            ShowStatusBar = true;
            AppleShowAllFiles = true;
            FXEnableExtensionChangeWarning = true;
            AppleShowAllExtensions = true;
            QuitMenuItem = true;
            CreateDesktop = false;
          };
          system.keyboard.remapCapsLockToEscape = true;
        };

        # Contents from darwin/env.nix
        my-env = { pkgs, lib, config, ... }: { # Added missing lib, config
          environment.systemPackages = with pkgs; [ kitty terminal-notifier ];
          environment.variables = { };
          programs.nix-index.enable = true;
          fonts.packages = with pkgs; [ emacs-all-the-icons-fonts ];
          system.keyboard.enableKeyMapping = true;
          system.keyboard.remapCapsLockToControl = true;
          system.keyboard.nonUS.remapTilde = true;
          services.emacsd = {
            package = pkgs.emacs30-nox.override {
              withNativeCompilation = false;
              noGui = true;
            };
            enable = false;
          };
          security.pam.services.sudo_local.touchIdAuth = true;
        };

        # Contents from darwin/homebrew.nix
        my-homebrew = { config, lib, ... }:
          let
            inherit (lib) mkIf;
            mkIfCaskPresent = cask:
              mkIf (lib.any (x: x.name == cask) config.homebrew.casks);
            brewEnabled = config.homebrew.enable;
          in {
            environment.shellInit = mkIf brewEnabled
              ''eval "$(${config.homebrew.brewPrefix}/brew shellenv)" '';
            programs.fish.interactiveShellInit = mkIf brewEnabled ''
              if test -d (brew --prefix)"/share/fish/completions"; set -p fish_complete_path (brew --prefix)/share/fish/completions; end; if test -d (brew --prefix)"/share/fish/vendor_completions.d"; set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d; end '';
            homebrew.enable = true;
            homebrew.onActivation.cleanup = "zap";
            homebrew.global.brewfile = true;
            homebrew.taps = [ "homebrew/services" "nrlquaker/createzap" ];
            homebrew.masApps = { };
            homebrew.casks = [
              "1password"
              "amethyst"
              "brave-browser"
              "backblaze"
              "cryptomator"
              "discord"
              "fuse"
              "ghostty"
              "google-drive"
              "keyclu"
              "raycast"
              "superhuman"
              "vlc"
              "signal"
              "flux"
            ];
            environment.variables.SSH_AUTH_SOCK =
              mkIfCaskPresent "1password-cli"
              "/Users/${config.users.primaryUser.username}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
            homebrew.brews = [ "mas" "gs" "ffmpeg" "plz-cli" ];
          };

        # Contents from modules/darwin/services/emacsd.nix
        services-emacsd = { config, lib, pkgs, ... }:
          with lib;
          let cfg = config.services.emacsd;
          in {
            options = {
              services.emacsd = {
                enable = mkOption {
                  type = types.bool;
                  default = false;
                  description = "Whether to enable the Emacs Daemon.";
                };
                package = mkOption {
                  type = types.path;
                  default = pkgs.emacs30-nox.override {
                    withNativeCompilation = false;
                    noGui = true;
                  };
                  description =
                    "This option specifies the emacs package to use.";
                };
                additionalPath = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  example = [ "/Users/my_user_name" ];
                  description =
                    "This option specifies additional PATH that the emacs daemon would have. Typically if you have binaries in your home directory that is what you would add your home path here. One caveat is that there won't be shell variable expansion, so you can't use $HOME for example ";
                };
                exec = mkOption {
                  type = types.str;
                  default = "emacs";
                  description = "Emacs command/binary to execute.";
                };
                term = mkOption {
                  type = types.str;
                  default = "xterm";
                  description = "terminfo to execute with emacs";
                };
              };
            };
            config = let
              emacsd = pkgs.writeShellScriptBin "emacsd" ''
                export TERMINFO_DIRS="${config.system.path}/share/terminfo"; export TERM=xterm-emacs; ${cfg.package}/bin/${cfg.exec} --fg-daemon '';
            in mkIf cfg.enable {
              launchd.user.agents.emacsd = {
                path = cfg.additionalPath ++ [ config.environment.systemPath ];
                serviceConfig = {
                  ProgramArguments =
                    [ "${pkgs.zsh}/bin/zsh" "${emacsd}/bin/emacsd" ];
                  RunAtLoad = true;
                  KeepAlive = true;
                  StandardErrorPath = "/tmp/emacsd.log";
                  StandardOutPath = "/tmp/emacsd.log";
                };
              };
            };
          };

        # Contents from modules/darwin/users.nix
        users-primaryUser = { lib, ... }:
          let inherit (lib) mkOption types;
          in {
            options.users.primaryUser = {
              username = mkOption {
                type = with types; nullOr string;
                default = null;
              };
              fullName = mkOption {
                type = with types; nullOr string;
                default = null;
              };
              email = mkOption {
                type = with types; nullOr string;
                default = null;
              };
              nixConfigDirectory = mkOption {
                type = with types; nullOr string;
                default = null;
              };
            };
          };

        # Contents from modules/darwin/programs/nix-index.nix
        #XXX: programs-nix-index = { config, lib, pkgs, ... }: { config = lib.mkIf config.programs.nix-index.enable { programs.fish.interactiveShellInit = '' function __fish_command_not_found_handler --on-event="fish_command_not_found" ${\ if config.programs.fish.useBabelfish then '' command_not_found_handle $argv '' else '' ${pkgs.bashInteractive}/bin/bash -c \ "source ${config.programs.nix-index.package}/etc/profile.d/command-not-found.sh; command_not_found_handle $argv" ''\ }$\ end ''; }; };
      };
      # --- End Darwin Modules ---

      # --- Inlined Home Manager Modules ---
      homeModulesAttrs = {
        # Contents from home/asdf.nix
        my-asdf = { pkgs, config, lib, ... }: # Added lib
          let
            asdf-config = pkgs.writeText "asdfrc"
              "legacy_version_file = no\\n use_release_candidates = no\\n always_keep_download = no\\n disable_plugin_short_name_repository = no\\n ${
                if pkgs.stdenv.isDarwin then
                  "java_macos_integration_enable = yes"
                else
                  ""
              }\\n ";
          in {
            home.file."${config.xdg.configHome}/asdf/asdfrc" = {
              source = asdf-config;
            };
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
          colors."manfred-touron" = {
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
        };

        # Contents from home/config.nix
        my-config = { lib, pkgs, config, ... }:
          let
            inherit (pkgs) stdenv;
            inherit (lib) mkIf;
            btopConfigContent = readFile "btop/btop.conf";
          in {
            home.file.".config/btop/btop.conf" = { text = btopConfigContent; };
            home.file.".npmrc" = {
              text = "prefix=${config.xdg.dataHome}/node_modules";
            };
            home.file.".aspell.config" = {
              text = ''
                dict-dir ""\n master en_US\n extra-dicts en en-computers.rws en-science.rws fr.rws\n '';
            };
          };

        # Contents from home/emacs.nix
        #XXX: my-emacs = { config, lib, pkgs, ... }:
        #  let my-emacs = pkgs.emacs30-nox.override { withNativeCompilation = false; noGui = true; }; emScriptContent = readFile "em"; rawEmacsScriptContent = readFile "raw-emacs"; em = pkgs.writeShellScriptBin "em" emScriptContent; raw-emacs-old = pkgs.writeShellScriptBin "raw-emacs-old" rawEmacsScriptContent;
        #  in { programs.emacs = { enable = true; package = my-emacs; extraConfig = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin '' ; macOS ls doesn't support --dired\n (setq dired-use-ls-dired nil)\n ''; extraPackages = epkgs: with epkgs; [ org better-defaults diminish ido-completing-read+ smex flycheck envrc company dockerfile-mode go-mode kubel lsp-mode lsp-pyright lsp-ui magit markdown-mode nix-mode nix-sandbox pretty-mode projectile yaml-mode polymode ]; }; home.packages = [ pkgs.sqlite em raw-emacs-old ]; home.file.".emacs.d/init.el" = { source = "${flakeRoot}/config/emacs/init.el"; }; home.file.".emacs.d/config.org" = { source = "${flakeRoot}/config/emacs/config.org"; }; programs.zsh.shellAliases = { emacs = "em"; emasc = "em"; eamsc = "em"; emaccs = "em"; emacss = "em"; raw-emacs = "${my-emacs}/bin/emacs"; }; };

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
              lg =
                "log --graph --abbrev-commit --decorate --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(italic)- %an%C(reset)%C(magenta bold)%d%C(reset)' --all";
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
              font_features =
                "+cv02 +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +ss10 +zero +onum";
            };
            programs.kitty.extras.useSymbolsFromNerdFont =
              "FiraCode Nerd Font Mono";
            programs.kitty.extras.colors = {
              enable = true;
              dark = theme.pkgThemes.kitty;
            };
            programs.truecolor.enable = true;
            programs.truecolor.useterm = "xterm-kitty";
            programs.truecolor.terminfo =
              "${pkgs.pkgs-stable.kitty.terminfo}/share/terminfo";
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

        # Contents from home/packages.nix
        my-packages = { config, lib, pkgs, ... }:
          let
            inherit (config.home) user-info homeDirectory;
            rust_home = "${config.xdg.dataHome}/rust";
          in {
            programs.ssh = {
              enable = true;
              controlMaster = "auto";
              controlPath = "${config.xdg.cacheHome}/ssh-%u-%r@%h:%p";
              controlPersist = "1800";
              forwardAgent = true;
              serverAliveInterval = 60;
              hashKnownHosts = true;
              extraConfig = lib.mkIf pkgs.stdenv.isDarwin ''
                IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" '';
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
            programs.bat.enable = true;
            programs.bat.themes = {
              catppuccin-macchiato = {
                src = pkgs.fetchFromGitHub {
                  owner = "catppuccin";
                  repo = "bat";
                  rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
                  sha256 =
                    "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
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
                eza
                btop
                tmate
                most
                lazydocker
                lazygit
                less
                (ripgrep.override { withPCRE2 = true; })
                cmake
                my-libvterm
                procs
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
          };

        # Contents from home/shells.nix
        my-shells = { config, lib, pkgs, ... }:
          let
            inherit (config.home) user-info homeDirectory;
            configDir = ".config";
            cacheDir = ".cache";
            dataDir = ".local/share";
            oh-my-zsh-custom = "${configDir}/oh-my-zsh";
            restart-service = pkgs.writeShellScriptBin "restart-service"
              "... script content ..."; # Placeholder
          in {
            xdg = {
              enable = true;
              configHome = "${homeDirectory}/${configDir}";
              cacheHome = "${homeDirectory}/${cacheDir}";
              dataHome = "${homeDirectory}/${dataDir}";
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
            programs.direnv.enable = true;
            programs.direnv.nix-direnv.enable = true;
            programs.htop.enable = true;
            programs.htop.settings.show_program_path = true;
            programs.zoxide.enable = true;
            programs.zsh = {
              enable = true;
              dotDir = ".config/zsh";
              plugins = [{
                name = "p10k-config";
                src = lib.cleanSource "${flakeRoot}/config/zsh/p10k";
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
                      config = "... fzf-tab config ...";
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
              initExtraFirst = "... p10k instant prompt ...";
              initExtra = "... zsh extras ...";
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
                  gnox =
                    "go run -C ~/go/src/github.com/gnolang/gno ./gnovm/cmd/gno";
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
          };

        # Contents from home/tmux.nix
        my-tmux = { config, lib, pkgs, ... }: {
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
                extraConfig =
                  "set -g @continuum-restore 'on'\\n set -g @continuum-save-interval '60'\\n ";
              }
            ];
            extraConfig = ''
              set -g default-command "${pkgs.zsh}/bin/zsh"\n bind-key -n C-S-Left swap-window -t -1\n bind-key -n C-S-Right swap-window -t +1\n set -g visual-activity off\n set -g visual-bell off\n set -g visual-silence off\n setw -g monitor-activity off\n set -g bell-action none\n setw -g clock-mode-colour colour5\n setw -g mode-style 'fg=colour1 bg=colour18 bold'\n set -g pane-border-style 'fg=colour9 bg=colour0'\n set -g pane-active-border-style 'bg=colour5 fg=colour9'\n set -g display-panes-time 3000\n set -g status-position bottom\n set -g status-justify left\n set -g status-style 'bg=colour16 fg=colour137 dim'\n set -g status-interval 5\n setw -g window-status-current-style 'fg=colour1 bg=colour21 bold'\n setw -g window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '\n setw -g window-status-style 'fg=colour9 bg=colour18'\n setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '\n setw -g window-status-bell-style 'fg=colour255 bg=colour1 bold'\n set -g status-left " #[fg=colour9]#S "\n set -g status-left-length 100\n set -g status-right-length 100\n set -g status-right '#{prefix_highlight} #[fg=colour1,bg=colour18,nobold,nounderscore,noitalics]#[fg=colour121,bg=colour18] %l:%M %p  %d %b %Y  #[fg=colour1,bg=colour18,nobold,nounderscore,noitalics]#[fg=colour1,bg=colour21,bold] #H #[fg=colour1,bg=colour21,nobold,nounderscore,noitalics]#[fg=colour21,bg=colour1]  #(rainbarf --battery --remaining --no-rgb) '\n set -g message-style 'fg=colour232 bg=colour6 bold'\n set -g mouse off\n set-option -g allow-rename off\n '';
          };
        };

        # Contents from modules/home/colors/default.nix
        colors-module-options = { lib, ... }:
          let inherit (lib) mkOption types;
          in {
            options = {
              colors = mkOption {
                default = { };
                type = types.attrsOf (types.submodule mkColorschemeOptions);
              };
            };
          };

        # Contents from modules/home/programs/kitty/extras.nix
        programs-kitty-extras = { config, lib, pkgs, ... }:
          with lib;
          let
            cfg = config.programs.kitty.extras;
            setToKittyConfig = with generators;
              toKeyValue { mkKeyValue = mkKeyValueDefault { } " "; };
            writeKittyConfig = fileName: config:
              pkgs.writeTextDir "${fileName}" (setToKittyConfig config);
            kitty-colors = pkgs.symlinkJoin {
              name = "kitty-colors";
              paths = [
                (writeKittyConfig "dark-colors.conf" cfg.colors.dark)
                (writeKittyConfig "light-colors.conf" cfg.colors.light)
              ];
            };
            term-background = pkgs.writeShellScriptBin "term-background"
              "... script content ..."; # Placeholder
            term-light = pkgs.writeShellScriptBin "term-light"
              "${term-background}/bin/term-background light";
            term-dark = pkgs.writeShellScriptBin "term-dark"
              "${term-background}/bin/term-background dark";
            socket = "unix:/tmp/mykitty";
          in {
            options.programs.kitty.extras = {
              colors = {
                enable = mkOption {
                  type = types.bool;
                  default = false;
                  description = "...";
                };
                dark = mkOption {
                  type = with types; attrsOf str;
                  default = { };
                  description = "...";
                };
                light = mkOption {
                  type = with types; attrsOf str;
                  default = { };
                  description = "...";
                };
                common = mkOption {
                  type = with types; attrsOf str;
                  default = { };
                  description = "...";
                };
                default = mkOption {
                  type = types.enum [ "dark" "light" ];
                  default = "dark";
                  description = "...";
                };
              };
              useSymbolsFromNerdFont = mkOption {
                type = types.str;
                default = "";
                example = "JetBrainsMono Nerd Font";
                description = "...";
              };
            };
            config = mkIf config.programs.kitty.enable {
              home.packages =
                mkIf cfg.colors.enable [ term-light term-dark term-background ];
              programs.kitty.settings = optionalAttrs cfg.colors.enable
                (cfg.colors.common // cfg.colors.${cfg.colors.default} // {
                  allow_remote_control = "yes";
                  listen_on = socket;
                }) // optionalAttrs (cfg.useSymbolsFromNerdFont != "") {
                  symbol_map =
                    "U+E5FA-U+E62B,... ${cfg.useSymbolsFromNerdFont}"; # Placeholder
                };
              programs.kitty.darwinLaunchOptions =
                mkIf pkgs.stdenv.isDarwin [ "--listen-on ${socket}" ];
            };
          };

        # Contents from modules/home/programs/truecolor/default.nix
        programs-truecolor = { config, lib, pkgs, ... }:
          with lib;
          let cfg = config.programs.truecolor;
          in {
            options.programs.truecolor = {
              enable = mkEnableOption "truecolor";
              useterm = mkOption {
                type = types.str;
                default = "xterm-256colors";
                description = "term to use";
              };
              terminfo = mkOption {
                type = types.str;
                default = "/usr/share/terminfo";
                description = "terminfo path to use";
              };
            };
            config = let
              xterm-source = pkgs.writeText "xterm.terminfo"
                "... terminfo content ..."; # Placeholder
              xterm-emacs = pkgs.runCommandLocal "xterm-emacs" {
                output = [ "terminfo" ];
                nativeBuildInputs = [ pkgs.ncurses ];
              }
                "mkdir -p $out/share/terminfo; export TERMINFO_DIRS=${cfg.terminfo}; tic -x -o $out/share/terminfo ${xterm-source} ";
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
            pluginExtra = types.submodule ({ ... }: {
              options = {
                name = mkOption { type = types.str; };
                source = mkOption { type = types.path; };
                config = mkOption { type = types.str; };
              };
            });
            themeExtra = types.submodule ({ ... }: {
              options = {
                name = mkOption { type = types.str; };
                source = mkOption { type = types.path; };
              };
            });
          in {
            options.programs.zsh.oh-my-zsh.extras = {
              plugins = mkOption {
                type = types.listOf pluginExtra;
                default = [ ];
                description = "list of extra plugins";
              };
              themes = mkOption {
                type = types.listOf themeExtra;
                default = [ ];
                description = "list of extra themes";
              };
            };
            config = let
              pluginsList = (map (p: {
                name =
                  "${config.programs.zsh.oh-my-zsh.custom}/plugins/${p.name}";
                value = {
                  source = p.source;
                  recursive = true;
                };
              }) cfg.plugins);
              themesList = (map (t: {
                name =
                  "${config.programs.zsh.oh-my-zsh.custom}/themes/${t.name}";
                value = {
                  source = t.source;
                  recursive = true;
                };
              }) cfg.themes);
              configExtra = concatStringsSep "\n"
                (map (p: "## ${p.name} config\\n\\n${p.config}")
                  (filter (p: p.config != "") cfg.plugins));
            in mkIf config.programs.zsh.oh-my-zsh.enable {
              home.file = listToAttrs (pluginsList ++ themesList);
              programs.zsh.initExtra = mkIf (configExtra != "")
                "# oh-my-zsh plugins config\\n\\n${configExtra}";
            };
          };

        # Module defining the home.user-info structure (originally inline in flake.nix)
        home-user-info = { lib, ... }: {
          options.home.user-info = {
            username = lib.mkOption {
              type = with lib.types; nullOr string;
              default = null;
            };
            fullName = lib.mkOption {
              type = with lib.types; nullOr string;
              default = null;
            };
            email = lib.mkOption {
              type = with lib.types; nullOr string;
              default = null;
            };
            nixConfigDirectory = lib.mkOption {
              type = with lib.types; nullOr string;
              default = null;
            };
          };
        };
      };
      # --- End Home Manager Modules ---

      # Pre-calculate the module lists
      darwinModuleList = self.lib.attrValues darwinModulesAttrs;
      homeModuleList = self.lib.attrValues homeModulesAttrs;

    in {

      # Add some additional functions to `lib` (KEEP THIS if mkDarwinSystem uses it)
      lib = inputs.nixpkgs-unstable.lib.extend (_: _: {
        mkDarwinSystem = import ./lib/mkDarwinSystem.nix inputs;
        lsnix = import ./lib/lsnix.nix;
      });

      overlays = {
        pkgs-master = _: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };
        pkgs-stable = _: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };
        pkgs-unstable = _: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };
        pkgs-silicon = _: prev:
          optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            pkgs-x86 = import inputs.nixpkgs-unstable {
              system = "x86_64-darwin";
              inherit (nixpkgsDefaults) config;
            };
          };
        my-inputs = final: prev: {
          spacemacs = inputs.spacemacs;
          doomemacs = inputs.doomemacs;
          chemacs2 = inputs.chemacs2;
          zsh-plugins.fast-syntax-highlighting =
            inputs.fast-syntax-highlighting;
          zsh-plugins.fzf-tab = inputs.fzf-tab;
          zsh-plugins.powerlevel10k = inputs.powerlevel10k;
        };
        my-libvterm = import ./overlays/libvterm.nix;
        my-retry = import ./overlays/retry.nix;
      };

      # System outputs ------------------------------------------------------------------------- {{{

      darwinConfigurations = rec {
        bootstrap-x86 = makeOverridable darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsDefaults; } ];
        }; # Keep direct import
        bootstrap-arm = bootstrap-x86.override { system = "aarch64-darwin"; };

        moul-dorado = makeOverridable self.lib.mkDarwinSystem (primaryUserInfo
          // {
            system = "aarch64-darwin";
            modules = darwinModuleList
              ++ [ homeModulesAttrs."colors-module-options" ] ++ singleton {
                nixpkgs = nixpkgsDefaults;
                networking.computerName = "moul-dorado";
                networking.hostName = "moul-dorado";
                networking.knownNetworkServices =
                  [ "Wi-Fi" "USB 10/100/1000 LAN" ];
                nix.registry.my.flake = inputs.self;
              };
            inherit homeStateVersion;
            homeModules = homeModuleList ++ [ ];
          });
        moul-abilite = makeOverridable self.lib.mkDarwinSystem (primaryUserInfo
          // {
            system = "aarch64-darwin";
            modules = darwinModuleList
              ++ [ homeModulesAttrs."colors-module-options" ] ++ singleton {
                nixpkgs = nixpkgsDefaults;
                networking.computerName = "moul-abilite";
                networking.hostName = "moul-abilite";
                networking.knownNetworkServices =
                  [ "Wi-Fi" "USB 10/100/1000 LAN" ];
                nix.registry.my.flake = inputs.self;
              };
            inherit homeStateVersion;
            homeModules = homeModuleList ++ [ ];
          });
        moul-scutum = makeOverridable self.lib.mkDarwinSystem (primaryUserInfo
          // {
            system = "aarch64-darwin";
            modules = darwinModuleList
              ++ [ homeModulesAttrs."colors-module-options" ] ++ singleton {
                nixpkgs = nixpkgsDefaults;
                networking.computerName = "moul-scutum";
                networking.hostName = "moul-scutum";
                networking.knownNetworkServices =
                  [ "Wi-Fi" "USB 10/100/1000 LAN" ];
                nix.registry.my.flake = inputs.self;
              };
            inherit homeStateVersion;
            homeModules = homeModuleList ++ [ ];
          });
        moul-volans = makeOverridable self.lib.mkDarwinSystem (primaryUserInfo
          // {
            system = "x86_64-darwin";
            modules = darwinModuleList
              ++ [ homeModulesAttrs."colors-module-options" ] ++ singleton {
                nixpkgs = nixpkgsDefaults;
                networking.computerName = "moul-volans";
                networking.hostName = "moul-volans";
                networking.knownNetworkServices =
                  [ "Wi-Fi" "USB 10/100/1000 LAN" ];
                nix.registry.my.flake = inputs.self;
              };
            inherit homeStateVersion;
            homeModules = homeModuleList ++ [ ];
          });
        moul-pyxis = makeOverridable self.lib.mkDarwinSystem ({
          username = "moul2";
          fullName = "";
          email = "94029+moul@users.noreply.github.com";
          nixConfigDirectory = "/Users/moul2/nixpkgs";
        } // {
          system = "aarch64-darwin";
          modules = darwinModuleList
            ++ [ homeModulesAttrs."colors-module-options" ] ++ singleton {
              nixpkgs = nixpkgsDefaults;
              networking.computerName = "moul-pyxis";
              networking.hostName = "moul-pyxis";
              networking.knownNetworkServices =
                [ "Wi-Fi" "USB 10/100/1000 LAN" ];
              nix.registry.my.flake = inputs.self;
            };
          inherit homeStateVersion;
          homeModules = homeModuleList ++ [ ];
        });
        githubCI = self.darwinConfigurations.moul-dorado.override {
          system = "x86_64-darwin";
          username = "runner";
          nixConfigDirectory = "/Users/runner/work/nixpkgs/nixpkgs";
          extraModules =
            singleton { homebrew.enable = self.lib.mkForce false; };
        };
      };

      homeConfigurations = {
        cloud = home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs-unstable
            (nixpkgsDefaults // { system = "x86_64-linux"; });
          modules = homeModuleList
            ++ [ homeModulesAttrs."colors-module-options" ] ++ singleton
            ({ config, ... }: {
              home.user-info = primaryUserInfo // {
                nixConfigDirectory = "${config.home.homeDirectory}/nixpkgs";
              };
              home.username = config.home.user-info.username;
              home.homeDirectory = "/home/${config.home.username}";
              home.stateVersion = homeStateVersion;
            });
        };
        lyra = home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs-unstable
            (nixpkgsDefaults // { system = "x86_64-linux"; });
          modules = homeModuleList
            ++ [ homeModulesAttrs."colors-module-options" ] ++ singleton
            ({ config, ... }: {
              home.user-info = primaryUserInfo // {
                nixConfigDirectory = "${config.home.homeDirectory}/nixpkgs";
              };
              home.username = config.home.user-info.username;
              home.homeDirectory = "/home/${config.home.username}";
              home.stateVersion = homeStateVersion;
            });
        };
        githubCI = home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs-unstable
            (nixpkgsDefaults // { system = "x86_64-linux"; });
          modules = homeModuleList
            ++ [ homeModulesAttrs."colors-module-options" ] ++ singleton
            ({ config, ... }: {
              home.user-info = ciUserInfo // {
                nixConfigDirectory = "${config.home.homeDirectory}/nixpkgs";
              };
              home.username = config.home.user-info.username;
              home.homeDirectory = "/home/${config.home.username}";
              home.stateVersion = homeStateVersion;
            });
        };
      };
      # }}}

    } // flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages =
        import inputs.nixpkgs-unstable (nixpkgsDefaults // { inherit system; });
      devShells = let pkgs = self.legacyPackages.${system};
      in {
        asdf = pkgs.mkShell {
          name = "asdf";
          inputsFrom = attrValues { inherit (pkgs) asdf-vm; };
          shellHook = ''
            if [ -f "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh" ]; then . "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"; fi\n fpath=(${pkgs.asdf-vm}/share/asdf-vm/completions $fpath)\n if [ -f "''${ASDF_DATA_DIR}/.asdf/plugins/java/set-java-home.zsh" ]; then . "''${ASDF_DATA_DIR}/.asdf/plugins/java/set-java-home.zsh"; fi\n '';
        };
      };
    });
}
