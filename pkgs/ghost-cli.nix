{ fetchFromGitHub
, mkYarnPackage
}:

let
  pname = "ghost-cli";
  version = "1.25.3";

  src = fetchFromGitHub {
    owner = "tryghost";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hlgGOV3FFnHzyOfLG/hcXTzOTHiVhNLW6Fz0lethezM=";
  };
in

mkYarnPackage {
  inherit pname src version;
  name = "ghost";
}
