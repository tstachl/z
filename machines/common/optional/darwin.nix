{ inputs, outputs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ] ++ (builtins.attrValues outputs.darwinModules);

  services.nix-daemon.enable = true;
  programs.nix-index.enable = true;

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

      trackpad = {
        ActuationStrength = 0;
        Clicking = null;
        Dragging = null;
        FirstClickThreshold = 1;
        SecondClickThreshold = 1;
        TrackpadRightClick = null;
        TrackpadThreeFingerDrag = null;
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        PMPrintingExpandedStateForPrint = true;
       _HIHideMenuBar = true;
       "com.apple.swipescrolldirection" = true;
      };

      screencapture.location = "/tmp";

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    rosetta.enable = true;
  };

  # Add ability to used TouchID for sudo authentication
  # Also not allowed on work computer?
  security.pam.enableSudoTouchIdAuth = true;
}
