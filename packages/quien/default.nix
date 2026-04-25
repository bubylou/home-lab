{
  nix-update-script,
  lib,
  fetchFromGitHub,
  buildGoModule,
  ...
}: let
  pname = "quien";
  version = "0.7.1";
  vendorHash = "sha256-q1HAlPIYe/nd5pYW+vZIABxfASlcFXhGNV71SY2ggsc=";
  gitHash = "sha256-ICz+lVXqmD/zozI8pQ9FKpFEq+9ZZXlRzqDM6GTAk1g=";
in
  buildGoModule {
    inherit pname version vendorHash;
    src = fetchFromGitHub {
      owner = "retlehs";
      repo = pname;
      tag = "v${version}";
      hash = gitHash;
    };

    env.CGO_ENABLED = "0";
    ldflags = [
      "-s"
      "-w"
      "-X main.version=${version}"
    ];

    passthru.updateScript = nix-update-script {};

    meta = {
      description = "A better WHOIS lookup tool";
      homepage = "https://benword.com/quien-a-better-whois-and-domain-intelligence-toolkit";
      license = lib.licenses.mit;
    };
  }
