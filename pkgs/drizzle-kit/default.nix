{ buildNpmPackage
, darwin
, fetchurl
, lib
, libtool
, python3
, pkg-config
, stdenv
}:

buildNpmPackage rec {
  pname = "drizzle-kit";
  version = "0.20.4";

  src = fetchurl {
    url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
    hash = "sha256-X//z4Ue3fIP5oYEa1HGDGzjTGhVH2iUz3buY8xb5JEk=";
  };

  nativeBuildInputs = [
    darwin.cctools
    libtool
    python3
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.cctools
  ];

  npmDepsHash = "sha256-VDnBOJCJ6RAdQTBd8t/Ng4tEubnM0dhHfbpI/PwSKEU=";
  dontNpmBuild = true;

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  meta = with lib; {
    description = "DrizzleKit - is a CLI migrator tool for DrizzleORM";
    homepage = "https://github.com/drizzle-team/drizzle-kit-mirror#readme";
    license = licenses.mit;
    # maintainers = with maintainers; [ winter ];
  };
}
