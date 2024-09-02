{ pkgs, plugins, stdenv, lib, ... }:

stdenv.mkDerivation rec {
  pname = "caddy";
  version = "2.7.6";
  dontUnpack = true;
  sandbox = false;

  nativeBuildInputs = with pkgs; [ git go xcaddy ];
  buildInputs = with pkgs; [ nss ];

  configurePhase = ''
    export GOCACHE="$TMPDIR/go-cache"
    export GOPATH="$TMPDIR/go"
  '';

  buildPhase =
    let
      pluginArgs =
        lib.concatMapStringsSep " " (plugin: "--with ${plugin}") plugins;
    in
    ''
      runHook preBuild
      ${pkgs.xcaddy}/bin/xcaddy build "v${version}" ${pluginArgs}
      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    mv caddy "$out/bin"
    runHook postInstall
  '';

  meta.mainProgram = "caddy";
}
