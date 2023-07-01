{ pkgs, ... }:
pkgs.dockerTools.buildImageWithNixDb {
  name = "devenv";
  tag = "1.0";
  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    pathsToLink = [ "/bin" ];
    paths = [
      # nix-store uses cat program to display results as specified by
      # the image env variable NIX_PAGER.
      pkgs.home-manager
      pkgs.nix
      pkgs.neovim
    ];
  };

  extraCommands = ''
    #!${pkgs.runtimeShell}
    ${pkgs.home-manager}/bin/home-manager \
      --extra-experimental-features "nix-command flakes" \
      switch \
        --flake github:tstachl/z#thomas
  '';

  config = {
    Env = [ "USER=nobody" ];
    Cmd = [ "${pkgs.neovim}/bin/nvim" "/workspace" ];
  };
}
