{ inputs, outputs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ] ++ (builtins.attrValues outputs.darwinModules);

  services.nix-daemon.enable = true;
  programs.nix-index.enable = true;

  # TODO: needs a mkIf linux-builder is enabled
  launchd.daemons.linux-builder.serviceConfig = {
    StandardOutPath = "/var/log/darwin-builder.log";
    StandardErrorPath = "/var/log/darwin-builder.log";
  };

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
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        PMPrintingExpandedStateForPrint = true;
        _HIHideMenuBar = true;
        "com.apple.swipescrolldirection" = true;
      };

      screencapture.location = "/tmp";

      trackpad = {
        ActuationStrength = 0;
        Clicking = true;
        Dragging = null;
        FirstClickThreshold = 1;
        SecondClickThreshold = 1;
        TrackpadRightClick = null;
        TrackpadThreeFingerDrag = true;
      };
    };

    rosetta.enable = true;
  };

  security.pam.enableSudoTouchIdAuth = true;
  security.pam.enablePamReattach = true;
}
