{ config, pkgs, ... }:
let
  inherit (config.xdg) configHome;
in
{
  programs.password-store = {
    enable = true;

    settings = {
      PASSWORD_STORE_DIR = "${configHome}/pass";
      PASSWORD_STORE_KEY = "ED5EAAA8E895B23A";
      PASSWORD_STORE_CLIP_TIME = "45";
      PASSWORD_STORE_GENERATED_LENGTH = "34";
      PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
    };

    package = pkgs.pass.withExtensions (exts: [
      exts.pass-otp
    ]);
  };
}
