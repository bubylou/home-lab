{
  rustPlatform,
  pkg-config,
  pipewire,
  nodejs,
  kdePackages,
  lib,
  git,
  fetchFromGitHub,
}: let
  pname = "pipeweaver";
  version = "0.1.5";
  gitHash = "sha256-rejID6f/y1W/klRREaCaM54DpXqM+JWEYVw5cwk1XPg=";
  cargoHash = "sha256-usP9Te84OMv0Dfmx82n3KqEhSEpWSMkZZmfPrjZtLfk=";
in
  rustPlatform.buildRustPackage {
    inherit pname version cargoHash;
    src = fetchFromGitHub {
      owner = "pipeweaver";
      repo = pname;
      rev = "v${version}";
      hash = gitHash;
    };

    nativeBuildInputs = [
      kdePackages.wrapQtAppsHook
      rustPlatform.bindgenHook
      pkg-config
      nodejs
      git
    ];

    buildInputs = [
      kdePackages.qtwebengine
      pipewire
    ];

    meta = {
      description = "PipeWeaver is a tool to communicate with pipewire to manage streaming audio";
      homepage = "https://github.com/pipeweaver/pipeweaver";
      license = lib.licenses.mit;
    };
  }
