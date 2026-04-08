{
  transcodingSupport ? true,
  mpv,
  lib,
  fetchFromGitHub,
  ffmpeg,
  buildGoModule,
}: let
  pname = "gonic";
  version = "v0.20.1";
  gitHash = "sha256-tW+GuNMMeiPf5XInR1BN2L7ommWh1SPClbRew8/2+cA=";
  vendorHash = "sha256-ynoIR4S02v3qec7447feuu/igFWR20VQVbL0GbTBpqM=";

  src = fetchFromGitHub {
    owner = "sentriz";
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
