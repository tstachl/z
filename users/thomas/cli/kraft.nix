{ pkgs, outputs, ... }:
{
  home.packages = with pkgs; [ unstable.kraft ];
  home.sessionVariables = {
    KRAFTCLOUD_METRO = "fra0";
    KRAFTCLOUD_TOKEN = "${outputs.lib.readSecret "kraft"}";
  };
}
