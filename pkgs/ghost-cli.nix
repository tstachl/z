{ fetchFromGitHub
, mkYarnPackage
}:

let
  pname = "ghost-cli";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "tryghost";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6yHP08bZuveASDuY9CyvaM6u/+d8h5EiamvUWbHrvgM=";
  };
in

mkYarnPackage {
  inherit pname src version;
  name = "ghost";
}
