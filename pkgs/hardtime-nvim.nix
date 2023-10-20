{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPluginFrom2Nix {
  pname = "hardtime.nvim";
  version = "2023-08-21";
  src = fetchFromGitHub {
    owner = "m4xshen";
    repo = "hardtime.nvim";
    rev = "778ab462991aa51681e13dea9f4bbe39c336fd73";
    sha256 = "sha256-zT1PGeSMpYmErnWESZcRff6QfcMCjptnGYJw/tH9wm8=";
  };
  meta.homepage = "https://github.com/m4xshen/hardtime.nvim";
}
