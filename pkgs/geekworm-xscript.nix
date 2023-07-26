{ pkgs ? import <nixpkgs> {} }:

with pkgs;

stdenv.mkDerivation rec {
  name = "geekworm-xscript";
  version = "c45cc13eced2eae34b716a814bcf5462a9ad857a";

  src = fetchFromGitHub {
    owner  = "geekworm-com";
    repo   = "xscript";
    rev    = version;
    sha256 = "sha256-Ue+4GGeShFKIyg1Pa2gbLeB5Z6Ev3vuYoWsa9ZeSbE0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    # make the output directory
    mkdir -p "$out/bin"

    # copy the scripts and make them executable
    for file in x-c1-fan.sh x-c1-pwr.sh x-c1-softsd.sh; do
      cat $file | sed 's/\/bin\/sleep/sleep/g' > $out/bin/$file
      chmod +x $out/bin/$file
      wrapProgram $out/bin/$file \
        --prefix PATH : ${lib.makeBinPath [ gawk coreutils ]}
    done
  '';

  meta.platforms = lib.platforms.linux;
}
