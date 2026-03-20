{
  pkgs,
  rustPlatform,
  lib,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vykar";
  version = "0.12.7";

  src = fetchFromGitHub {
    owner = "borgbase";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-YUAGVrUGye9LlMNCfkFbxFLR5Le9k7E6Vx/y5o66uCY=";
  };

  cargoLock.lockFile = finalAttrs.src + "/Cargo.lock";

  buildInputs = with pkgs; [
    glib
    gtk3
    libayatana-appindicator
    xdotool
  ];

  nativeBuildInputs = with pkgs; [
    fontconfig
    pkg-config
  ];

  meta = {
    description = "Fast, encrypted, deduplicated backups in Rust — with friendly YAML config, a desktop GUI, and support for S3, custom REST and SFTP storage.";
    homepage = "https://github.com/borgbase/vykar";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [bubylou];
  };
})
