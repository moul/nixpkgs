# darwin.nix
# Consolidated Darwin modules
{ inputs, pkgs, lib, config, flakeRoot, ... }:

let
  # Helper function using explicit flakeRoot
  readFile = path: builtins.readFile "${flakeRoot}/config/${path}";
in
{
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
  my-defaults = { ... }: {
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
  my-env = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ kitty terminal-notifier ];
    environment.variables = {
      # TERMINFO_DIRS = "${pkgs.pkgs-stable.kitty.terminfo.outPath}/share/terminfo";
    };
    programs.nix-index.enable = true;
    fonts.packages = with pkgs; [
      emacs-all-the-icons-fonts
      # (nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" "FiraCode" ]; })
    ];
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToControl = true;
    system.keyboard.nonUS.remapTilde = true;
    services.emacsd = {
      package = pkgs.emacs30-nox.override { withNativeCompilation = false; noGui = true; };
      enable = false;
    };
    security.pam.services.sudo_local.touchIdAuth = true;
  };

  # Contents from darwin/homebrew.nix
  my-homebrew = { config, lib, ... }:
    let
      inherit (lib) mkIf;
      mkIfCaskPresent = cask: mkIf (lib.any (x: x.name == cask) config.homebrew.casks);
      brewEnabled = config.homebrew.enable;
    in {
      environment.shellInit = mkIf brewEnabled ''
        eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
      '';
      programs.fish.interactiveShellInit = mkIf brewEnabled ''
        if test -d (brew --prefix)"/share/fish/completions"
          set -p fish_complete_path (brew --prefix)/share/fish/completions
        end
        if test -d (brew --prefix)"/share/fish/vendor_completions.d"
          set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
        end
      '';
      homebrew.enable = true;
      homebrew.onActivation.cleanup = "zap";
      homebrew.global.brewfile = true;
      homebrew.taps = [
        "homebrew/services"
        "nrlquaker/createzap"
      ];
      homebrew.masApps = {
        # ... your MAS apps ...
      };
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
      environment.variables.SSH_AUTH_SOCK = mkIfCaskPresent "1password-cli"
        "/Users/${config.users.primaryUser.username}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      homebrew.brews = [
        "mas"
        "gs"
        "ffmpeg"
        "plz-cli"
      ];
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
            default = pkgs.emacs30-nox.override{ withNativeCompilation = false; noGui = true; };
            description = "This option specifies the emacs package to use.";
          };
          additionalPath = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "/Users/my_user_name" ];
            description = ''
              This option specifies additional PATH that the emacs daemon would have.
              Typically if you have binaries in your home directory that is what you would add your home path here.
              One caveat is that there won't be shell variable expansion, so you can't use $HOME for example
            '';
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
          export TERMINFO_DIRS="${config.system.path}/share/terminfo";
          export TERM=xterm-emacs
          ${cfg.package}/bin/${cfg.exec} --fg-daemon
        '';
      in mkIf cfg.enable {
        launchd.user.agents.emacsd = {
          path = cfg.additionalPath ++ [ config.environment.systemPath ];
          serviceConfig = {
            ProgramArguments = [ "${pkgs.zsh}/bin/zsh" "${emacsd}/bin/emacsd" ];
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
        username = mkOption { type = with types; nullOr string; default = null; };
        fullName = mkOption { type = with types; nullOr string; default = null; };
        email = mkOption { type = with types; nullOr string; default = null; };
        nixConfigDirectory = mkOption { type = with types; nullOr string; default = null; };
      };
    };

  # Contents from modules/darwin/programs/nix-index.nix
  programs-nix-index = { config, lib, pkgs, ... }: {
    config = lib.mkIf config.programs.nix-index.enable {
    };
  };
}