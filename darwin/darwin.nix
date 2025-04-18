# Consolidated Darwin Modules
{ config, lib, pkgs, ... }:

let
  # === From homebrew.nix let block ===
  inherit (lib) mkIf;
  mkIfCaskPresent = cask:
    mkIf (lib.any (x: x.name == cask) config.homebrew.casks);
  brewEnabled = config.homebrew.enable;
in
lib.mkMerge [
  # === bootstrap.nix ===
  {
    # Nix configuration ------------------------------------------------------------------------------
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

    # nix.configureBuildUsers = true;

    # Auto upgrade nix package and the daemon service.
    # services.nix-daemon.enable = true;

    # Shells ----------------------------------------------------------------------------------------
    # Add shells installed by nix to /etc/shells file
    environment.shells = with pkgs; [ bashInteractive zsh ];

    # Install and setup ZSH to work with nix(-darwin) as well
    programs.zsh.enable = true;
    environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";

    environment.extraInit = ''export PATH="$HOME/bin:$PATH"'';

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 5;
  }

  # === defaults.nix ===
  {
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
  }

  # === env.nix ===
  {
    # Networking
    # networking.dns = [ ];

    # Apps
    # `home-manager` currently has issues adding them to `~/Applications`
    # Issue: https://github.com/nix-community/home-manager/issues/1341
    environment.systemPackages = with pkgs; [ kitty terminal-notifier ];

    # https://github.com/nix-community/home-manager/issues/423
    environment.variables = {
      # TERMINFO_DIRS = "${pkgs.pkgs-stable.kitty.terminfo.outPath}/share/terminfo";
    };
    programs.nix-index.enable = true;

    # Fonts
    fonts.packages = with pkgs;
      [
        # recursive
        emacs-all-the-icons-fonts
        #(nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" "FiraCode" ]; })
      #nerd-fonts.Iosevka
        #nerd-fonts.FiraCode
        #nerd-fonts.JetBrainsMono
      ];

    # Keyboard
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToControl = true;
    system.keyboard.nonUS.remapTilde = true;
    # hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}]}'

  # emacs daemon
  services.emacsd = {
    package = pkgs.emacs30-nox.override { withNativeCompilation = false; noGui = true; };
    enable = false;
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;
  }

  # === homebrew.nix ===
  {
    environment.shellInit = mkIf brewEnabled ''
      eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
    '';

    # https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
    # For some reason if the Fish completions are added at the end of `fish_complete_path` they don't
    # seem to work, but they do work if added at the start.
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
      #"homebrew/cask"
      #"homebrew/cask-drivers"
      #"homebrew/cask-fonts"
      #"homebrew/cask-versions"
      #"homebrew/core"
      "homebrew/services"
      "nrlquaker/createzap"
    ];

    # Prefer installing application from the Mac App Store
    homebrew.masApps = {
      #iStatMenus = 1319778037;
      #MicrosoftRemoteDesktop = 1295203466;
      #WiFiExplorer = 494803304;
      #iNetNetworkScanner = 403304796;
      #oneSec = 1532875441;
      #Actions = 1586435171;
      #Backtrack = 1477089520;
      #DaisyDisk = 411643860;
      #Deliveries = 290986013;
      #Keynote = 409183694;
      #Monodraw = 920404675;
      #NextDNS = 1464122853;
      #Numbers = 409203825;
      #Pages = 409201541;
      #Pocket = 568494494;
      #Screens = 1224268771;
      #Slack = 803453959;
      #Tailscale = 1475387142;
      #Transmit = 1436522307;
      #Twitter = 1482454543;

      # OLD to reconsider
      #LogicPro = 634148309;
      #Model15 = 1041465860;
      #PixelmatorPro = 1289583905;
      #Canva = 897446215;
      #YubicoAuthenticator = 1497506650;
      #Grammarly = 1462114288;
      #Trello = 1278508951;
      #Fantastical = 975937182;
      #GarageBand = 682658836;
      #iMovie = 408981434;

      # FIXME: optionals if darwin >= 12
      #Infuse = 1136220934;
      #Actions = 1586435171;
      #oneSec = 1532875441;
      #Controller = 1198176727;
    };

    # If an app isn't available in the Mac App Store, or the version in the App Store has
    # limitiations, e.g., Transmit, install the Homebrew Cask.
    homebrew.casks = [
      "1password"
      #"1password-cli"
      "amethyst"
      "brave-browser"
      "backblaze"
      #"blobby-volley2"
      "cryptomator"
      "discord"
      #"docker"
      #"firefox-developer-edition"
      "fuse"
      "ghostty"
      #"fuse-t"
      #"google-chrome"
      "google-drive"
      #"ipfs"
      #"keybase"
      "keyclu"
      #"krisp"
      #"loom"
      #"minecraft"
      #"netspot"
      #"notion"
      #"nvidia-geforce-now"
      "raycast"
      #"ubersicht"
      "superhuman"
      "vlc"
      "signal"
      #"roam-research"
      #"obsidian"
      # "amethyst"
      # "anki"
      # "arq"
      # "balenaetcher"
      # "cleanmymac"
      # "element"
      # "etrecheckpro"
      # "firefox"
      "flux"
      # "gpg-suite"
      # "hammerspoon"
      # "obsbot-me-tool"
      # "obsbot-tinycam"
      # "obsidian"
      # "parallels"
      # "postman"
      # "protonvpn"
      # "raindropio"
      # "secretive"
      # "signal"
      # "skype"
      # "steam"
      # "tor-browser"
      # "transmission"
      # "transmit"
      # "visual-studio-code"
      #"yubico-yubikey-manager"
      #"yubico-yubikey-personalization-gui"
    ];

    # Configuration related to casks
    environment.variables.SSH_AUTH_SOCK = mkIfCaskPresent "1password-cli"
      "/Users/${config.users.primaryUser.username}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

    # For cli packages that aren't currently available for macOS in `nixpkgs`.Packages should be
    # installed in `../home/default.nix` whenever possible.
    homebrew.brews = [
      "mas"
      "gs"
      "ffmpeg"
      "plz-cli"
      #"Homeport/tap/termshot"
      #"hub"
      #"golang"
      #"mosh"
      #"emacs"
      #"tmux"
      #"gvm"
      #"entr"
      #"watch"
      #"youtube-dl"
      #"encfs"
      #"swift-format"
      #"swiftlint"
    ];
  }

  # === jankyborders.nix (commented out as in flake.nix) ===
  # {
  #   services.jankyborders.enable = true;
  # }
] 