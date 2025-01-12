{ inputs, outputs, lib, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ] ++ (builtins.attrValues outputs.darwinModules);

  services.nix-daemon.enable = true;
  programs.nix-index.enable = true;

  #nix.linux-builder = {
  #  enable = true;
  #  ephemeral = true;
  #  maxJobs = 4;
  #  config = {
  #    virtualisation = {
  #      darwin-builder = {
  #        diskSize = 40 * 1024;
  #        memorySize = 8 * 1024;
  #      };
  #      cores = 6;
  #    };
  #  };
  #};

  # TODO: needs a mkIf linux-builder is enabled
  launchd.daemons.linux-builder.serviceConfig = {
    StandardOutPath = "/var/log/darwin-builder.log";
    StandardErrorPath = "/var/log/darwin-builder.log";
  };

  # TODO: move into module:
  system.activationScripts.extraActivation.text = lib.mkAfter ''
    # disable spotlight
    echo "disable spotlight..." >&2
    mdutil -i off /
  '';

  system = {
    keyboard = {
      enableKeyMapping = true;
      userKeyMapping = [{
        # map caps lock to skhd leader
        HIDKeyboardModifierMappingSrc = 30064771129;
        HIDKeyboardModifierMappingDst = 30064771298;
      }];
    };

    defaults = {
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

      dock = {
        autohide = true;
        orientation = "bottom";
        wvous-bl-corner = 10; # put display to sleep
        wvous-br-corner = 14; # quick note
        wvous-tl-corner = 1; # disabled
        wvous-tr-corner = 1; # disabled
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = true;
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      loginwindow = {
        DisableConsoleAccess = false;
        GuestEnabled = false;
        LoginwindowText = null;
        PowerOffDisabledWhileLoggedIn = false;
        RestartDisabled = false;
        RestartDisabledWhileLoggedIn = false;
        SHOWFULLNAME = true;
        ShutDownDisabled = false;
        ShutDownDisabledWhileLoggedIn = false;
        SleepDisabled = false;
        autoLoginUser = null;
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        KeyRepeat = 6;
        InitialKeyRepeat = 25;
        NSAutomaticCapitalizationEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = true;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSWindowResizeTime = 0.001;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
        # WebKitDeveloperExtras = true;
        _HIHideMenuBar = true;
        "com.apple.swipescrolldirection" = true;
      };

      screencapture.location = "/tmp";

      screensaver.askForPassword = true;

      trackpad = {
        ActuationStrength = 0;
        Clicking = true;
        Dragging = null;
        FirstClickThreshold = 1;
        SecondClickThreshold = 1;
        TrackpadRightClick = null;
        TrackpadThreeFingerDrag = true;
      };

      WindowManager.StageManagerHideWidgets = true;
      WindowManager.StandardHideDesktopIcons = true;
      WindowManager.StandardHideWidgets = true;
    };

    rosetta.enable = true;
  };

  security.pam.enableSudoTouchIdAuth = true;
  security.pam.enablePamReattach = true;
}
