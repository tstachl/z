{ pkgs, ... }:
{
  # fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    liberation_ttf
  ];
}
