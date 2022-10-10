{ config, lib, ... }:

let
  inherit (lib) mkIf;
  mkIfCaskPresent = cask:
    mkIf (lib.any (x: x.name == cask) config.homebrew.casks);
  brewEnabled = config.homebrew.enable;

in {
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
    "homebrew/cask"
    "homebrew/cask-drivers"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/core"
    "homebrew/services"
    "nrlquaker/createzap"
  ];

  # Prefer installing application from the Mac App Store
  homebrew.masApps = {
    "iStat Menus" = 1319778037;
    "Logic Pro" = 634148309;
    "Microsoft Remote Desktop" = 1295203466;
    #"Model 15" = 1041465860;
    "Pixelmator Pro" = 1289583905;
    "WiFi Explorer" = 494803304;
    "Yubico Authenticator" = 1497506650;
    "one sec" = 1532875441;
    "Grammarly: Writing App" = 1462114288;
    "Canva: Design, Photo & Video" = 897446215;
    Actions = 1586435171;
    Backtrack = 1477089520;
    Controller = 1198176727;
    DaisyDisk = 411643860;
    Deliveries = 290986013;
    Fantastical = 975937182;
    GarageBand = 682658836;
    iMovie = 408981434;
    Keynote = 409183694;
    Monodraw = 920404675;
    NextDNS = 1464122853;
    Numbers = 409203825;
    Pages = 409201541;
    Pocket = 568494494;
    Screens = 1224268771;
    Slack = 803453959;
    Tailscale = 1475387142;
    Transmit = 1436522307;
    Twitter = 1482454543;
    Canva = 897446215;
    Infuse = 1136220934;
    Trello = 1278508951;
  };

  # If an app isn't available in the Mac App Store, or the version in the App Store has
  # limitiations, e.g., Transmit, install the Homebrew Cask.
  homebrew.casks = [
    "1password"
    "1password-cli"
    "backblaze"
    "discord"
    "docker"
    "ipfs"
    "keybase"
    "krisp"
    "loom"
    "notion"
    "nvidia-geforce-now"
    "raycast"
    "superhuman"
    "vlc"
    # "amethyst"
    # "anki"
    # "arq"
    # "balenaetcher"
    # "cleanmymac"
    # "element"
    # "etrecheckpro"
    # "firefox"
    # "google-chrome"
    # "google-drive"
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
