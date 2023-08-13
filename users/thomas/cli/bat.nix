{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = { theme = "Kanagawa"; };
    themes = {
      nord = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "crabique";
        repo = "Nord-plist";
        rev = "0d655b23d6b300e691676d9b90a68d92b267f7ec";
        sha256 = "sha256-YUogcLO+W1hD0X/nsworGS1SHsOolp/g9N0rQJ/Q5wc=";
      } + "/Nord.tmTheme");
      kanagawa = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "codeandgin";
        repo = "kanagawa-sublime-text";
        rev = "0b4979a6837c0ca626965d42402f1a5332df521a";
        sha256 = "sha256-C8OoMcVX11KK/yKQE6/WFIL9bcLxh0m3PdtvTp3FS2k=";
      } + "/kanagawa.sublime-color-scheme");
    };
  };
}
