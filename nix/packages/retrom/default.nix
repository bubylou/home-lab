{
  webkitgtk_4_1,
  rustPlatform,
  protobuf,
  pnpmConfigHook,
  pnpm,
  pkg-config,
  perl,
  openssl,
  nodejs,
  libsoup_3,
  lib,
  glib,
  gtk3,
  fetchPnpmDeps,
  fetchFromGitHub,
  faketty,
  cargo-tauri,
}: let
  pname = "retrom";
  version = "v0.8.0";
  cargoHash = "sha256-LrPYIGLSoQ/YSDlMYYf93L03zPASVmrgSaah5dPQWPo=";
  gitHash = "sha256-RCEOmj5a8HHBfNElRpCGUIsr1aiEyqzyWElVzCQj9aU=";
  pnpmHash = "sha256-r3TFgV07do9qDSv9prUyzRMi4buj4QkhhrtHqJ4p37Y=";

  src = fetchFromGitHub {
    owner = "JMBeresford";
    repo = pname;
    tag = version;
    hash = gitHash;
  };

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    fetcherVersion = 3;
    hash = pnpmHash;
  };
in
  rustPlatform.buildRustPackage {
    inherit pname version src cargoHash pnpmDeps;
    buildAndTestSubdir = "packages/client";

    nativeBuildInputs = [
      protobuf
      pnpmConfigHook
      pnpm
      pkg-config
      perl
      nodejs
      faketty
      cargo-tauri.hook
    ];

    buildInputs = [
      webkitgtk_4_1
      openssl
      libsoup_3
      glib
      gtk3
    ];

    buildPhase = ''
      faketty pnpm nx build:desktop retrom-client-web
      runHook tauriBuildHook
    '';

    meta = {
      description = "A centralized game library/collection management service with a focus on emulation";
      homepage = "https://github.com/JMBeresford/retrom";
      license = lib.licenses.gpl3;
    };
  }
