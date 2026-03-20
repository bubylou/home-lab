{
  pkgs,
  rustPlatform,
  lib,
  fetchFromGitHub,
}: let
  owner = "dan-online";
  pname = "autopulse";
  version = "1.6.0";
  hash = "sha256-Fmp8MyXCeeDbusfZiCUauZGveZ2AdCX6Z6WBAldh3Ro=";
in
  rustPlatform.buildRustPackage (finalAttrs: {
    inherit pname version;

    src = fetchFromGitHub {
      repo = finalAttrs.pname;
      tag = "v${finalAttrs.version}";
      inherit owner hash;
    };

    nativeBuildInputs = with pkgs; [
      pkg-config
      llvmPackages.clang
      llvmPackages.libclang
      git
      cmake
    ];

    buildInputs = with pkgs; [
      sqlite
      ncurses
      openssl
      libpq
      libiconv
    ];

    buildFeatures = [
      "postgres"
      "sqlite"
    ];

    cargoLock.lockFile = finalAttrs.src + "/Cargo.lock";

    meta = {
      description = "💫 automated lightweight service that updates media servers like Plex and Jellyfin based on notifications from media organizers like Sonarr and Radarr";
      homepage = "https://github.com/dan-online/autopulse";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [bubylou];
    };
  })
