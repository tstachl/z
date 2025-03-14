{ pkgs, lib, config, outputs, ... }:
let
  homeLocation = with pkgs.stdenv.hostPlatform;
    if isDarwin then "/Users" else "/home";
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
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nix = {
    package = lib.mkDefault pkgs.nixFlakes;
    settings.trusted-users = [ "thomas" ];
  };

  manual.manpages.enable = false;
  xdg.enable = true;

  home = {
    username = lib.mkDefault "thomas";
    homeDirectory = lib.mkDefault "${homeLocation}/${config.home.username}";
    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
      SHELL = "${pkgs.fish}/bin/fish";
    };
    stateVersion = lib.mkDefault "24.05";
  };
}
