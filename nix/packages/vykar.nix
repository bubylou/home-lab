{
  pkgs,
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vykar";
  version = "0.11.8";

  src = fetchFromGitHub {
    owner = "borgbase";
    repo = "vykar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iEG//jX7CEgPlW5cnCRq8n60V3ASjr/WkGTOXfRK010=";
  };

  cargoLock.lockFile = finalAttrs.src + "/Cargo.lock";
  nativeBuildInputs = with pkgs; [
    atk
    cairo
    fontconfig
    gcc
    glib
    gtk3
    gdk-pixbuf
    pango
    pkg-config
    xdotool
  ];

  meta = {
    description = " Fast, encrypted, deduplicated backups in Rust — with friendly YAML config, a desktop GUI, and support for S3, custom REST and SFTP storage.";
    homepage = "https://github.com/borgbase/vykar";
    license = lib.licenses.gpl3;
    maintainers = [];
  };
})
