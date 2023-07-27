{ lib
, stdenv
, rustPlatform
, fetchFromGitHub

, buildPackages
, cargo
, darwin
, lzo
, openssl
, pkg-config
, ronn
, rustc
, zlib
, nlohmann_json
, libiconv
}:

let
  pname = "zerotierone";
  version = "1.10.6";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "ZeroTierOne";
    rev = version;
    sha256 = "sha256-mapFKeF+8jMGkxSuHaw5oUdTdSQgAdxEwF/S6iyVLbY=";
  };

in stdenv.mkDerivation {
  inherit pname version src;

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "jwt-0.16.0" = "sha256-P5aJnNlcLe9sBtXZzfqHdRvxNfm6DPBcfcKOVeLZxcM=";
    };
  };
  postPatch = "cp ${./Cargo.lock} Cargo.lock";

  preConfigure = ''
    cmp ./Cargo.lock ./zeroidc/Cargo.lock || {
      echo 1>&2 "Please make sure that the derivation's Cargo.lock is identical to ./zeroidc/Cargo.lock!"
      exit 1
    }

    patchShebangs ./doc/build.sh
    substituteInPlace ./doc/build.sh \
      --replace '/usr/bin/ronn' '${buildPackages.ronn}/bin/ronn' \

    substituteInPlace ./make-linux.mk \
      --replace '-march=armv6zk' "" \
      --replace '-mcpu=arm1176jzf-s' ""

    substituteInPlace ./make-mac.mk \
      --replace '-arch x86_64' "" \
      --replace 'cd zeroidc && MACOSX_DEPLOYMENT_TARGET=$(MACOS_VERSION_MIN) cargo build --target=x86_64-apple-darwin $(EXTRA_CARGO_FLAGS)' "" \
      --replace 'target/x86_64-apple-darwin/$(RUST_VARIANT)/libzeroidc.a ' "" \
      --replace 'shell PWD' "shell pwd" \
      --replace 'MACOS_VERSION_MIN=10.13' "MACOS_VERSION_MIN=10.14" \
      --replace 'CORE_OBJS+=ext/x64-salsa2012-asm/salsa2012.o' "" \
      --replace '-isystem $(TOPDIR)/ext' "-isystem $(TOPDIR)/ext -isysroot ${buildPackages.darwin.xcode}/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
  '';

  nativeBuildInputs = [
    pkg-config
    ronn
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];
  buildInputs = [
    darwin.iproute2mac
    darwin.xcode
    lzo
    openssl
    zlib
    nlohmann_json
    libiconv
  ];

  enableParallelBuilding = true;

  buildFlags = [ "all" "selftest" ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  checkPhase = ''
    runHook preCheck
    ./zerotier-selftest
    runHook postCheck
  '';

  installFlags = [ "DESTDIR=$$out/upstream" ];

  postInstall = ''
    mv $out/upstream/usr/sbin $out/bin

    mkdir -p $man/share
    mv $out/upstream/usr/share/man $man/share/man

    rm -rf $out/upstream
  '';

  outputs = [ "out" "man" ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Create flat virtual Ethernet networks of almost unlimited size";
    homepage = "https://www.zerotier.com";
    license = licenses.bsl11;
    maintainers = with maintainers; [ sjmackenzie zimbatm ehmry obadz danielfullmer ];
    platforms = platforms.all;
  };
}
