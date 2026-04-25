{
  yarnConfigHook,
  stdenv,
  rustPlatform,
  pkg-config,
  openssl,
  nodejs,
  nix-update-script,
  makeWrapper,
  lib,
  fetchYarnDeps,
  fetchFromGitHub,
}: let
  pname = "stump";
  version = "0.1.1";
  cargoHash = "sha256-bIaC9jomWyl0UKJDw5rMvP1NvAvn0wwFfFOJCo4yJCY=";
  gitHash = "sha256-9nNfseazcrZOTXkhoJR/4tFQ4bzqSJ/NU2Sp4yd6Jz8=";
  yarnHash = "sha256-q3pV1yAgje8+WxzNBxJdYj5+sCYa6hAOyIEE62ukpqc=";

  src = fetchFromGitHub {
    owner = "stumpapp";
    repo = pname;
    rev = "v${version}";
    hash = gitHash;
  };

  frontend = stdenv.mkDerivation {
    inherit pname src version;

    yarnBuildScript = "web build";
    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      hash = yarnHash;
    };

    nativeBuildInputs = [
      yarnConfigHook
      nodejs
    ];

    installPhase = ''
      mv apps/web/dist $out
    '';
  };

  backend = rustPlatform.buildRustPackage {
    inherit pname src version cargoHash;

    preConfigure = ''
      export GIT_REV=${lib.substring 0 8 version}
    '';

    nativeBuildInputs = [
      pkg-config
      makeWrapper
    ];

    buildInputs = [
      openssl
    ];

    buildAndTestSubdir = "apps/server";
  };
in
  stdenv.mkDerivation {
    inherit pname src version;

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${backend}/bin/stump_server $out/bin/stump \
        --set STUMP_CLIENT_DIR ${frontend}
    '';

    passthru.updateScript = nix-update-script {};

    meta = {
      description = "A free and open source comics, manga and digital book server";
      homepage = "https://stumpapp.dev";
      license = lib.licenses.mit;
    };
  }
