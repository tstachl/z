{
  lib
, stdenv

, go
, xcaddy
}:

with lib;

stdenv.mkDerivation rec {
  pname = "caddy";
  version = "2.6.4";
  dontUnpack = true;

  nativeBuildInputs = [ go xcaddy ];
  plugins = [
    "github.com/caddy-dns/cloudflare"
  ];

  configurePhase = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
  '';

  buildPhase = let
    pluginArgs = concatMapStringsSep " " (plugin: "--with ${plugin}") plugins;
  in ''
    runHook preBuild
    ${xcaddy}/bin/xcaddy build "v${version}" ${pluginArgs}
    runHook postBuild
  '';


  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv caddy $out/bin
    runHook postInstall
  '';
}
