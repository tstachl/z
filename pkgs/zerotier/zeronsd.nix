{ lib
, rustPlatform
, fetchFromGitHub

, openssl
, pkg-config
, rustfmt
}:

let
  pname = "zeronsd";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TL0bgzQgge6j1SpZCdxv/s4pBMSg4/3U5QisjkVE6BE=";
  };
in

rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-WGap0j90obpJHiMNokCWg0Q3xIAqwvmiESg9NVnFMKE=";
  nativeBuildInputs = [ pkg-config openssl ];
  # invalid log level: invalid format
  doCheck = false;

  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  RUSTFMT = "${rustfmt}/bin/rustfmt";
}
