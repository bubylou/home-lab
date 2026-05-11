{
  wayland,
  vulkan-loader,
  udev,
  rustPlatform,
  pkg-config,
  makeWrapper,
  libxkbcommon,
  libxcb,
  libx11,
  lib,
  fontconfig,
  fetchFromGitHub,
  alsa-lib,
}: let
  pname = "ratty";
  version = "0.2.0";
  gitHash = "sha256-fDNlyTOhwI1nzNf2/Z9DWtTEdJCZEDogLu13ETbpJAw=";
in
  rustPlatform.buildRustPackage rec {
    inherit pname version;
    src = fetchFromGitHub {
      owner = "orhun";
      repo = pname;
      rev = "v${version}";
      hash = gitHash;
    };

    cargoLock = {lockFile = src + /Cargo.lock;};

    nativeBuildInputs = [
      pkg-config
      makeWrapper
    ];

    buildInputs = [
      vulkan-loader
      wayland
      udev
      libxkbcommon
      libxcb
      libx11
      fontconfig
      alsa-lib
    ];

    LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
    postInstall = ''
      wrapProgram $out/bin/ratty \
        --prefix LD_LIBRARY_PATH : ${LD_LIBRARY_PATH}
    '';

    meta = {
      description = "A GPU-rendered terminal emulator with inline 3D graphics";
      homepage = "https://ratty-term.org/";
      license = lib.licenses.mit;
    };
  }
