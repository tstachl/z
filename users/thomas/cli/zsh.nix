{
  programs.zsh = {
    enable = true;
    shellAliases = import ./shell-aliases.nix;
  };
}
