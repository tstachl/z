{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ skhd ];

  services.skhd = {
    enable = true;
    skhdConfig = ''
      # open terminal, blazingly fast
      cmd - return : ${pkgs.alacritty}/bin/alacritty

      # focus window
      alt - h : ${pkgs.yabai}/bin/yabai -m window --focus west
      alt - j : ${pkgs.yabai}/bin/yabai -m window --focus south
      alt - k : ${pkgs.yabai}/bin/yabai -m window --focus north
      alt - l : ${pkgs.yabai}/bin/yabai -m window --focus east

      # swap managed window
      shift + alt - h : ${pkgs.yabai}/bin/yabai -m window --swap west
      shift + alt - j : ${pkgs.yabai}/bin/yabai -m window --swap south
      shift + alt - k : ${pkgs.yabai}/bin/yabai -m window --swap north
      shift + alt - l : ${pkgs.yabai}/bin/yabai -m window --swap east

      # move managed window
      shift + alt + ctrl - h : ${pkgs.yabai}/bin/yabai -m window --warp west
      shift + alt + ctrl - j : ${pkgs.yabai}/bin/yabai -m window --warp south
      shift + alt + ctrl - k : ${pkgs.yabai}/bin/yabai -m window --warp north
      shift + alt + ctrl - l : ${pkgs.yabai}/bin/yabai -m window --warp east

      # rotate tree
      alt - r : ${pkgs.yabai}/bin/yabai -m space --rotate 90

      # toggle window fullscreen zoom
      alt - f : ${pkgs.yabai}/bin/yabai -m window --toggle zoom-fullscreen

      # alt - s : yabai -m window --toggle
      alt - s : ${pkgs.yabai}/bin/yabai -m window --toggle sticky;\
                ${pkgs.yabai}/bin/yabai -m window --toggle topmost;\
                ${pkgs.yabai}/bin/yabai -m window --toggle pip

      # toggle padding and gap
      alt - g : ${pkgs.yabai}/bin/yabai -m space --toggle padding; yabai -m space --toggle gap

      # float / unfloat window and center on screen
      alt - t : ${pkgs.yabai}/bin/yabai -m window --toggle float;\
                ${pkgs.yabai}/bin/yabai -m window --grid 4:4:1:1:2:2

      # toggle window split type
      alt - e : ${pkgs.yabai}/bin/yabai -m window --toggle split

      # balance size of windows
      shift + alt - 0 : ${pkgs.yabai}/bin/yabai -m space --balance

      # move window and focus desktop
      shift + alt - 1 : ${pkgs.yabai}/bin/yabai -m window --space 1; yabai -m space --focus 1
      shift + alt - 2 : ${pkgs.yabai}/bin/yabai -m window --space 2; yabai -m space --focus 2
      shift + alt - 3 : ${pkgs.yabai}/bin/yabai -m window --space 3; yabai -m space --focus 3
      shift + alt - 4 : ${pkgs.yabai}/bin/yabai -m window --space 4; yabai -m space --focus 4
      shift + alt - 5 : ${pkgs.yabai}/bin/yabai -m window --space 5; yabai -m space --focus 5
      shift + alt - 6 : ${pkgs.yabai}/bin/yabai -m window --space 6; yabai -m space --focus 6
      shift + alt - 7 : ${pkgs.yabai}/bin/yabai -m window --space 7; yabai -m space --focus 7
      shift + alt - 8 : ${pkgs.yabai}/bin/yabai -m window --space 8; yabai -m space --focus 8
      shift + alt - 9 : ${pkgs.yabai}/bin/yabai -m window --space 9; yabai -m space --focus 9


      # create desktop, move window and follow focus - uses jq for parsing json (brew install jq)
      shift + alt - n : ${pkgs.yabai}/bin/yabai -m space --create && \
                         index="$(${pkgs.yabai}/bin/yabai -m query --spaces --display | ${pkgs.jq}/bin/jq 'map(select(."native-fullscreen" == 0))[-1].index')"&& \
                         ${pkgs.yabai}/bin/yabai -m window --space "''${index}"&& \
                         ${pkgs.yabai}/bin/yabai -m space --focus "''${index}"

      # fast focus desktop
      alt - tab : ${pkgs.yabai}/bin/yabai -m space --focus recent
    '';
  };
}
