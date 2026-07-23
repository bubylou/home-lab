{
  nix-update-script,
  lib,
  fetchFromGitHub,
  buildGoModule,
  ...
}:
let
  pname = "quien";
  version = "0.12.0";
  vendorHash = "sha256-7gP6eN+lF90kSltQMHkVTTanogEAtbLnENdZTF9f98c=";
  gitHash = "sha256-HTTogbcBa/dOIZAl1sNCqZODlFk50N+94jDxQrWQwb8=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A better WHOIS lookup tool";
    homepage = "https://benword.com/quien-a-better-whois-and-domain-intelligence-toolkit";
    license = lib.licenses.mit;
  };
}
