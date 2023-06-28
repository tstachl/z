{ pkgs, lib, config, inputs, outputs, ... }:
let
  homeLocation = with pkgs.stdenv.hostPlatform;
    if isDarwin then "/Users" else "/home";
in
{
  imports = [
    ./features/cli
    ./features/nvim

    inputs.nur.hmModules.nur
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nix = {
    package = pkgs.nixFlakes;

    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };

    extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  manual.manpages.enable = false;

  programs = {
    bash.enable = true;
    fish.enable = true;
    home-manager.enable = false;
    zsh.enable = false;
  };

  xdg.enable = true;

  home = {
    username = lib.mkDefault "thomas";
    homeDirectory = lib.mkDefault "${homeLocation}/${config.home.username}";
    stateVersion = lib.mkDefault "23.05";
  };

  # home.sessionVariables = { SHELL = pkgs.fish + "/bin/fish"; };
}
