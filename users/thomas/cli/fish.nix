{ lib, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = import ./shell-aliases.nix;

    interactiveShellInit = lib.mkAfter ''
      ${lib.strings.fileContents (pkgs.fetchFromGitHub {
          owner = "rebelot";
          repo = "kanagawa.nvim";
          rev = "de7fb5f5de25ab45ec6039e33c80aeecc891dd92";
          sha256 = "sha256-f/CUR0vhMJ1sZgztmVTPvmsAgp0kjFov843Mabdzvqo=";
        } + "/extras/kanagawa.fish")}
    '';
  };
}
