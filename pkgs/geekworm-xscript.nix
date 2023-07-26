{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  name = "geekworm-xscript";
  version = "c45cc13eced2eae34b716a814bcf5462a9ad857a";

  src = pkgs.fetchFromGitHub {
    owner  = "geekworm-com";
    repo   = "xscript";
    rev    = version;
    sha256 = "sha256-Ue+4GGeShFKIyg1Pa2gbLeB5Z6Ev3vuYoWsa9ZeSbE0=";
  };

  installPhase = ''
    # make the output directory
    mkdir -p "$out/bin"

    # copy the scripts and make them executable
    for file in x-c1-fan.sh x-c1-pwr.sh x-c1-softsd.sh; do
      cp $file $out/bin/
      chmod +x $out/bin/$file
    done
  '';

  meta.platforms = pkgs.lib.platforms.linux;
}
