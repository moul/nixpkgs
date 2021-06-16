{ ... }:

{
  # Global
  system.defaults.NSGlobalDomain = {
    AppleMeasurementUnits = "Centimeters";
    AppleMetricUnits = 1;
    AppleShowScrollBars = "Automatic";
    AppleTemperatureUnit = "Celsius";
    InitialKeyRepeat = 15;
    KeyRepeat = 1;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
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
  };
}
