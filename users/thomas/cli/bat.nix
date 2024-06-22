{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = { theme = "kanagawa"; };
    themes = {
      nord = {
        src = pkgs.fetchFromGitHub {
          owner = "crabique";
          repo = "Nord-plist";
          rev = "0d655b23d6b300e691676d9b90a68d92b267f7ec";
          sha256 = "sha256-YUogcLO+W1hD0X/nsworGS1SHsOolp/g9N0rQJ/Q5wc=";
        };
        file = "/Nord.tmTheme";
      };

      kanagawa = {
        src = pkgs.fetchFromGitHub {
          owner = "rebelot";
          repo = "kanagawa.nvim";
          rev = "7b411f9e66c6f4f6bd9771f3e5affdc468bcbbd2";
          sha256 = "sha256-kV+hNZ9tgC8bQi4pbVWRcNyQib0+seQrrFnsg7UMdBE=";
        };
        file = "/extras/kanagawa.tmTheme";
      };
    };
  };
}
