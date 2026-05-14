{
  rustPlatform,
  lib,
  fetchFromGitHub,
}: let
  pname = "numa";
  version = "0.17.0";
  gitHash = "sha256-iotOiqnVWEF0WIgs+xcwav89da7FwR+3MIHFAwFPMFE=";

  src = fetchFromGitHub {
    owner = "razvandimescu";
    repo = pname;
    rev = "v${version}";
    hash = gitHash;
  };
in
  rustPlatform.buildRustPackage {
    inherit pname src version;
    cargoLock = {lockFile = src + /Cargo.lock;};
    meta = {
      description = "Portable DNS resolver in Rust";
      homepage = "https://github.com/razvandimescu/numa";
      license = lib.licenses.mit;
    };
  }
