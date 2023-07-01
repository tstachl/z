{ pkgs, ... }:
pkgs.dockerTools.buildLayeredImage {
  name = "devenv";
  tag = "1.0";

  config = {
    Cmd = [ "${pkgs.hello}/bin/hello" ];
  };
}
