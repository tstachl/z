{ pkgs, ... }:
let
  defaultOptions = [
    "--strip-cwd-prefix"
    "--hidden"
    "--exclude .git"
  ];
in
{
  home.packages = with pkgs; [ fd ];

  programs.fzf = {
    enable = true;
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd";
    changeDirWidgetOptions = [ "--type=d" ] ++ defaultOptions;
    defaultCommand = "${pkgs.fd}/bin/fd";
    defaultCommandOptions = defaultOptions;
    fileWidgetCommand = "${pkgs.fd}/bin/fd";
    fileWidgetOptions = [ "--type=f" ] ++ defaultOptions;
    tmux.enableShellIntegration = true;
  };
}
