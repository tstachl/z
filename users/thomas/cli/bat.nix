{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = { theme = "Nord"; };
    themes = {
      nord = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "crabique";
        repo = "Nord-plist";
        rev = "0d655b23d6b300e691676d9b90a68d92b267f7ec";
        sha256 = "sha256-YUogcLO+W1hD0X/nsworGS1SHsOolp/g9N0rQJ/Q5wc=";
      } + "/Nord.tmTheme");
    };
  };
}
