{ pkgs, lib, config, outputs, ... }:
let
  homelocation = with pkgs.stdenv.hostplatform;
    if isdarwin then "/users" else "/home";
in
{
  imports = [
    ./cli/bash.nix
    ./cli/bat.nix
    ./cli/fish.nix
    ./cli/git.nix
    ./cli/gnupg.nix
    ./cli/ssh.nix
    ./cli/starship.nix
    ./cli/zsh.nix
  ] ++ (builtins.attrvalues outputs.homemanagermodules);

  nix = {
    package = lib.mkdefault pkgs.nixflakes;
    settings.trusted-users = [ "thomas" ];
  };

  manual.manpages.enable = false;
  xdg.enable = true;

  home = {
    username = lib.mkdefault "thomas";
    homedirectory = lib.mkdefault "${homelocation}/${config.home.username}";
    sessionvariables = {
      editor = "${pkgs.neovim}/bin/nvim";
      shell = "${pkgs.fish}/bin/fish";
    };
    stateversion = lib.mkdefault "24.05";
  };
}
