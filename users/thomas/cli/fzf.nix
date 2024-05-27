{ pkgs, ... }:
{
  home.packages = with pkgs; [ fd ];

  programs.fzf = rec {
    # TODO(@tstachl): figure out why this is happening in tmux
    # fish: Unknown command: fzf_key_bindings
    # source /nix/store/.../share/fzf/key-bindings.fish && fzf_key_bindings
    enable = false;
    changeDirWidgetCommand = defaultCommand;
    changeDirWidgetOptions = [ "--type=d" ] ++ defaultOptions;
    defaultCommand = "${pkgs.fd}/bin/fd";
    defaultOptions = [
      "--strip-cwd-prefix"
      "--hidden"
      "--exclude .git"
    ];
    fileWidgetCommand = defaultCommand;
    fileWidgetOptions = [ "--type=f" ] ++ defaultOptions;
    tmux.enableShellIntegration = true;
  };
}
