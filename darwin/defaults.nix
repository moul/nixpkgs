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
    expose-group-apps = false;
    mru-spaces = false;
    tilesize = 25;
    show-recents = true;
    # Disable all hot corners
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
    # disable animation
    launchanim = false;
    autohide-delay = 0.1;
    autohide-time-modifier = 0.1;
    expose-animation-duration = 0.1;
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
    Clicking = false;
    TrackpadRightClick = true;
  };

  # Finder
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
