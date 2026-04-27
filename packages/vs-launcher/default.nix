{
  makeWrapper,
  makeDesktopItem,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  copyDesktopItems,
}: let
  pname = "vs-launcher";
  version = "1.5.8";
  gitHash = "sha256-SYpZSFyavD19sGuQhUrmVAbzx2Hs5nupsu2DkCymT4w=";
  npmDepsHash = "sha256-l/f5nrrcma6whgQyBntO0dY25XXW3e0681AuECLYGT4=";
in
  buildNpmPackage {
    inherit pname version npmDepsHash;
    src = fetchFromGitHub {
      owner = "XurxoMF";
      repo = pname;
      tag = version;
      hash = gitHash;
    };

    env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

    nativeBuildInputs = [
      makeWrapper
      electron
      copyDesktopItems
    ];

    postBuild = ''
      cp -r ${electron.dist} electron-dist
      chmod -R u+w electron-dist

      npm exec electron-builder -- --linux --dir \
          -c.electronDist=electron-dist \
          -c.electronVersion=${electron.version}
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/vs-launcher
      cp -r dist/linux-unpacked/* $out/share/vs-launcher

      install -Dm644 \
        $out/share/vs-launcher/resources/app.asar.unpacked/resources/icon.png \
        $out/share/icons/hicolor/512x512/apps/vs-launcher.png

      makeWrapper ${electron}/bin/electron $out/bin/vs-launcher \
        --add-flags $out/share/vs-launcher/resources/app.asar \
        --prefix UPDATE : false

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "vs-launcher";
        desktopName = "VS Launcher";
        exec = "vs-launcher %U";
        icon = "vs-launcher";
        genericName = "Vintage Story Launcher";
        keywords = [
          "launcher"
          "electron"
          "vintage"
          "mods"
        ];
        categories = [
          "Application"
          "Utility"
          "Game"
        ];
      })
    ];

    meta = {
      description = "Unofficial launcher and version manager for Vintage Story";
      homepage = "https://github.com/XurxoMF/vs-launcher";
      license = lib.licenses.mit;
    };
  }
