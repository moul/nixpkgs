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
    #"homebrew/cask"
    #"homebrew/cask-drivers"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    #"homebrew/core"
    "homebrew/services"
    "nrlquaker/createzap"
  ];

  # Prefer installing application from the Mac App Store
  homebrew.masApps = {
    iStatMenus = 1319778037;
    #LogicPro = 634148309;
    MicrosoftRemoteDesktop = 1295203466;
    #Model15 = 1041465860;
    #PixelmatorPro = 1289583905;
    WiFiExplorer = 494803304;
    #YubicoAuthenticator = 1497506650;
    #Grammarly = 1462114288;
    iNetNetworkScanner = 403304796;
    oneSec = 1532875441;
    #Canva = 897446215;
    Actions = 1586435171;
    Backtrack = 1477089520;
    DaisyDisk = 411643860;
    Deliveries = 290986013;
    #Fantastical = 975937182;
    #GarageBand = 682658836;
    #iMovie = 408981434;
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
    #Trello = 1278508951;

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
    "backblaze"
    #"blobby-volley2"
    "discord"
    #"docker"
    #"firefox-developer-edition"
    #"google-chrome"
    "google-drive"
    #"ipfs"
    #"keybase"
    "krisp"
    #"loom"
    #"minecraft"
    #"netspot"
    #"notion"
    #"nvidia-geforce-now"
    "raycast"
    #"ubersicht"
    "superhuman"
    "vlc"
    #"signal"
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
