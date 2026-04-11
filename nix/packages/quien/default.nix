{
  buildGoModule,
  fetchFromGitHub,
  lib,
}: let
  pname = "quien";
  version = "v0.1.1";
  vendorHash = "sha256-q1HAlPIYe/nd5pYW+vZIABxfASlcFXhGNV71SY2ggsc=";
  src = fetchFromGitHub {
    owner = "retlehs";
    repo = pname;
    tag = version;
    hash = "sha256-BfN3JlJxAlfskUEioZfC/ouIjRHSHQzhS+QX34AXdLg=";
  };
in
  buildGoModule {
    inherit pname version src vendorHash;
    meta = {
      description = "A better WHOIS lookup tool";
      homepage = "";
      license = lib.licenses.mit;
    };
  }
