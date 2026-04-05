{
  yarnConfigHook,
  stdenv,
  rustPlatform,
  pkg-config,
  openssl,
  nodejs,
  makeWrapper,
  lib,
  fetchYarnDeps,
  fetchFromGitHub,
}: let
  pname = "stump";
  version = "v0.1.0";
  gitHash = "sha256-FavhqSckX/d3UAxLMUb3EwrNolUjZrkZNISP7GwMR58=";
  yarnHash = "sha256-mG9kTS5bNgrjYkltAByw0kLmR1tFNSedrbkBCvDRxiA=";

  src = fetchFromGitHub {
    owner = "stumpapp";
    repo = pname;
    rev = version;
    hash = gitHash;
  };

  frontend = stdenv.mkDerivation {
    inherit pname src version;
    yarnBuildScript = "web build";
    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      hash = yarnHash;
    };

    nativeBuildInputs = [yarnConfigHook nodejs];
    installPhase = "mv apps/web/dist $out";
  };

  backend = rustPlatform.buildRustPackage {
    inherit pname src version;
    preConfigure = "export GIT_REV=${lib.substring 0 8 version}";

    nativeBuildInputs = [pkg-config makeWrapper];
    buildInputs = [openssl];
    buildAndTestSubdir = "apps/server";

    cargoLock = {
      lockFile = src + "/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
  };
in
  stdenv.mkDerivation {
    inherit pname src version;
    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${backend}/bin/stump_server $out/bin/stump \
        --set STUMP_CLIENT_DIR ${frontend}
    '';

    meta = {
      description = "A free and open source comics, manga and digital book server";
      homepage = "https://stumpapp.dev";
      license = lib.licenses.mit;
    };
  }
