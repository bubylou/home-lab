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
  gtk3,
  glib-networking,
  fetchPnpmDeps,
  fetchFromGitHub,
  faketty,
  cargo-tauri,
  buildFHSEnv,
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

  retrom = rustPlatform.buildRustPackage {
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
      gtk3
      glib-networking
    ];

    buildPhase = ''
      faketty pnpm nx build:desktop retrom-client-web
      runHook tauriBuildHook
    '';

    meta = {
      description = "A centralized game library/collection management service with a focus on emulation";
      homepage = "https://github.com/JMBeresford/retrom";
      license = lib.licenses.gpl3;
      platforms = lib.platforms.linux;
      mainProgram = "Retrom";
    };
  };
in
  buildFHSEnv {
    inherit (retrom) pname version meta;
    executableName = retrom.meta.mainProgram;
    runScript = lib.getExe retrom;

    targetPkgs = pkgs:
      with pkgs; [
        zstd.out
        zlib
        tzdata
        readline
        python311
        postgresql.lib
        openssl.out
        lz4.lib
        libxslt.out
        libxml2_13.out
        libossp_uuid
        krb5.lib
        glibc
      ];

    extraInstallCommands = ''
      ln -s ${retrom}/share $out
    '';
  }
