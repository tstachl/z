{ inputs, outputs, ... }:
{
  imports = [
    outputs.darwinModules
    inputs.home-manager.darwinModules.home-manager
  ];

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
      dock = {
        autohide = true;
        orientation = "bottom";
      };

      finder = {
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
      };

      NSGlobalDomain = {
       _HIHideMenuBar = true;
       "com.apple.swipescrolldirection" = false;
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
