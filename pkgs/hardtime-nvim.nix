{ buildVimPluginFrom2Nix, fetchFromGitHub }:
buildVimPluginFrom2Nix {
  pname = "hardtime.nvim";
  version = "2023-08-21";
  src = fetchFromGitHub {
    owner = "m4xshen";
    repo = "hardtime.nvim";
    rev = "778ab462991aa51681e13dea9f4bbe39c336fd73";
    sha256 = "";
  };
  meta.homepage = "https://github.com/m4xshen/hardtime.nvim";
}
