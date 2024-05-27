{ pkgs, ... }:
{
  home.packages = with pkgs; [ fd ];

  programs.fzf = rec {
    enable = true;
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
