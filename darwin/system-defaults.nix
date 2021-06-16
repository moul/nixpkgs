{ ... }:

# https://github.com/LnL7/nix-darwin/blob/master/tests/system-defaults-write.nix
# https://gist.github.com/dannysmith/9369950

{
  # Global
  system.defaults.NSGlobalDomain = {
    AppleMeasurementUnits = "Centimeters";
    AppleMetricUnits = 1;
    AppleShowScrollBars = "Automatic";
    AppleTemperatureUnit = "Celsius";
    InitialKeyRepeat = 12;
    KeyRepeat = 0;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    "com.apple.springing.delay" = "0.0";
    #NSAutomaticWindowAnimationsEnabled = false;
    _HIHideMenuBar = true;
  };

  # Firewall
  system.defaults.alf = {
    globalstate = 1;
    allowsignedenabled = 1;
    allowdownloadsignedenabled = 1;
    stealthenabled = 1;
  };

  # Dock and Mission Control
  system.defaults.dock = {
    autohide = true;
    expose-group-by-app = false;
    mru-spaces = false;
    tilesize = 25;
    orientation = "left";
    autohide-delay = "0.2";
  };

  # Keyboard
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Login and lock screen
  system.defaults.loginwindow = {
    GuestEnabled = false;
    DisableConsoleAccess = true;
  };

  # Spaces
  system.defaults.spaces.spans-displays = false;

  # Trackpad
  system.defaults.trackpad = {
    Clicking = true;
    TrackpadRightClick = true;
  };

  # Finder
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    QuitMenuItem = true;
    FXEnableExtensionChangeWarning = false;
    CreateDesktop = false;
  };
}
