{
  postgresql,
  postgresqlTestHook,
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "kompanion";
  version = "v0.0.4";

  src = fetchFromGitHub {
    owner = "vanadium23";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-abYrKijxKcx9DFwIp+++tlHZgaUNkeSRCrFoRRstZuI=";
  };

  modules = ./gomod2nix.toml;
  vendorHash = "sha256-c6fSGqjnq3d5qXj/IrvE+lULSf1pAjqbjkVPNaRG8+s=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
  ];

  env = {
    KOMPANION_PG_URL = "postgres://$PGUSER@$PGHOST/$PGDATABASE";
    KOMPANION_AUTH_USERNAME = "user";
    KOMPANION_AUTH_PASSWORD = "password";
  };

  meta = {
    description = "a self hosted backend for bookworms, tightly coupled with KOReader";
    homepage = "https://github.com/vanadium23/kompanion";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [bubylou];
  };
})
