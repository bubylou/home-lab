{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "kompanion";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "vanadium23";
    repo = "${finalAttrs.pname}";
    tag = "v${finalAttrs.version}";
    hash = "sha256-abYrKijxKcx9DFwIp+++tlHZgaUNkeSRCrFoRRstZuI=";
  };

  modules = ./gomod2nix.toml;
  vendorHash = "sha256-c6fSGqjnq3d5qXj/IrvE+lULSf1pAjqbjkVPNaRG8+s=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "a self hosted backend for bookworms, tightly coupled with KOReader";
    homepage = "https://github.com/vanadium23/kompanion";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [bubylou];
  };
})
