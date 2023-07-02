{ ... }:
{
  programs.zsh = {
    enable = true;

    shellAliases = {
      g = "git";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      snrs = "sudo nixos-rebuild switch --flake .#$(hostname)";
    };
  };
}
