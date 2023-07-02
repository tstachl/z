{ ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = import ./shell-aliases.nix;
  };
}
