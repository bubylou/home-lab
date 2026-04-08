{
  transcodingSupport ? true,
  mpv,
  lib,
  fetchFromGitHub,
  ffmpeg,
  buildGoModule,
}: let
  pname = "gonic";
  version = "9c258bd";
  gitHash = "sha256-bysoCeKTu0giPZaoGzFWaoKwqPVZQ35s9XeHtltcL1c=";
  vendorHash = "sha256-a7cg2JSb/nMipUgTZUj3R8rQjtsA8HxfsC7pMuG3V7o=";

  src = fetchFromGitHub {
    owner = "yaemiku";
    repo = pname;
    rev = version;
    sha256 = gitHash;
  };
in
  buildGoModule {
    inherit pname version src vendorHash;
    postPatch =
      lib.optionalString transcodingSupport ''
        substituteInPlace \
          transcode/transcode.go \
          --replace-fail \
            '`ffmpeg' \
            '`${lib.getBin ffmpeg}/bin/ffmpeg'
      ''
      + ''
        substituteInPlace \
          jukebox/jukebox.go \
          --replace-fail \
            '"mpv"' \
            '"${lib.getBin mpv}/bin/mpv"'
      ''
      + ''
        substituteInPlace server/ctrlsubsonic/testdata/test* \
          --replace-quiet \
            '"audio/flac"' \
            '"audio/x-flac"'
      '';

    meta = {
      homepage = "https://github.com/sentriz/gonic";
      description = "music streaming server / free-software subsonic server API implementation";
      license = lib.licenses.gpl3Plus;
    };
  }
