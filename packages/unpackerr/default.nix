{
  nix-update-script,
  lib,
  fetchFromGitHub,
  buildGoModule,
}: let
  pname = "unpackerr";
  version = "0.14.5";
  vendorHash = "sha256-wWIw0gNn5tqRq0udzPy/n2OkiIVESpSotOSn2YlBNS4=";
  gitHash = "sha256-uQwpdgV6ksouW9JTuiiuQjxBGOE/ypDW769kNJgWrHw=";
in
  buildGoModule {
    inherit pname version vendorHash;
    src = fetchFromGitHub {
      owner = "davidnewhall";
      repo = pname;
      tag = "v${version}";
      hash = gitHash;
    };

    ldflags = [
      "-s"
      "-w"
      "-X golift.io/version.Version=${version}"
    ];

    passthru.updateScript = nix-update-script {};

    meta = {
      description = "Extracts downloads for Radarr, Sonarr, Lidarr - Deletes extracted files after import";
      homepage = "https://github.com/davidnewhall/unpackerr";
      license = lib.licenses.mit;
    };
  }
