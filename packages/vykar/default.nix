{
  zenity,
  xdotool,
  wayland,
  stdenv,
  rustPlatform,
  python3,
  pkg-config,
  makeWrapper,
  libxkbcommon,
  libGL,
  libayatana-appindicator,
  lib,
  gsettings-desktop-schemas,
  inputs,
  gtk3,
  glib,
  fontconfig,
  fetchFromGitHub,
}: let
  pname = "vykar";
  version = "v0.12.12";
  skiaBinaries = inputs."skia-binaries-${stdenv.hostPlatform.system}";

  src = fetchFromGitHub {
    owner = "borgbase";
    repo = pname;
    tag = version;
    hash = "sha256-gmSmMqC9FFo/PakeKOv6d77mapePejN6iF7Zg1/KPB4=";
  };
in
  rustPlatform.buildRustPackage {
    inherit pname version src;
    cargoLock.lockFile = src + "/Cargo.lock";

    buildInputs = [
      glib
      gtk3
      libayatana-appindicator
      xdotool
    ];

    nativeBuildInputs = [
      fontconfig
      makeWrapper
      pkg-config
      python3
    ];

    env = {
      SKIA_BINARIES_URL = "file://${skiaBinaries}";
    };

    # GUI shared library dependencies
    postInstall = lib.optionalString stdenv.isLinux ''
      wrapProgram $out/bin/vykar-gui \
        --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          libxkbcommon
          fontconfig
          libGL
          libayatana-appindicator
          gtk3
        ]
      } \
        --prefix PATH : ${lib.makeBinPath [zenity]} \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
    '';

    meta = {
      description = "Fast, encrypted, deduplicated backups in Rust";
      longDescription = ''
        Fast, encrypted, deduplicated backups in Rust
        with friendly YAML config, a desktop GUI, and
        support for S3, custom REST and SFTP storage.
      '';
      homepage = "https://github.com/borgbase/vykar";
      license = lib.licenses.gpl3;
    };
  }
