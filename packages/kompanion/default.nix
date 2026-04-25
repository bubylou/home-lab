{
  lib,
  fetchFromGitHub,
  buildGoModule,
}: let
  pname = "kompanion";
  version = "0.0.4";
  gitHash = "sha256-abYrKijxKcx9DFwIp+++tlHZgaUNkeSRCrFoRRstZuI=";
  vendorHash = "sha256-c6fSGqjnq3d5qXj/IrvE+lULSf1pAjqbjkVPNaRG8+s=";
in
  buildGoModule {
    inherit pname version vendorHash;
    src = fetchFromGitHub {
      owner = "vanadium23";
      repo = pname;
      rev = "v${version}";
      hash = gitHash;
    };

    ldflags = [
      "-X main.version=${version}"
    ];

    doCheck = false;

    meta = {
      description = "a self hosted backend for bookworms, tightly coupled with KOReader";
      homepage = "https://github.com/vanadium23/kompanion";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [bubylou];
    };
  }
