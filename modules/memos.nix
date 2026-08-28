{
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  perSystem = { pkgs, ... }: rec {
    checks.memos = packages.memos;
    packages.memos = pkgs.callPackage (
      {
        stdenvNoCC,
        pnpmConfigHook,
        pnpm_10,
        nodejs,
        lib,
        fetchPnpmDeps,
        fetchFromGitHub,
        buildGoModule,
        ...
      }:
      let
        pname = "memos";
        version = "0.30.0";
        vendorHash = "sha256-nyUBXPC8nt+7s2jFHohF0PWBGky24ZSXWtSI4XVf2kU=";
        gitHash = "sha256-MXvEMJN/XyZux/qL/9qZYkbo6fQzYFeCWHxFCtN1M8o=";
        pnpm = pnpm_10;

        src = fetchFromGitHub {
          owner = "usememos";
          repo = pname;
          tag = "v${version}";
          hash = gitHash;
        };

        frontend = stdenvNoCC.mkDerivation {
          pname = "frontend";
          inherit version src;
          pnpmDeps = fetchPnpmDeps {
            inherit pname version src;
            inherit pnpm;
            sourceRoot = "${src.name}/web";
            fetcherVersion = 3;
            hash = "sha256-4oUA0z6VXL0belhK23wZgwCpGmLqDnEez3nMA/uHUTw=";
          };

          pnpmRoot = "web";

          nativeBuildInputs = [
            nodejs
            pnpmConfigHook
            pnpm
          ];

          buildPhase = ''
            runHook preBuild
            pnpm -C web build
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            cp -r web/dist $out
            runHook postInstall
          '';
        };
      in
      buildGoModule {
        inherit
          pname
          src
          version
          vendorHash
          ;

        ldflags = [
          "-X github.com/usememos/memos/internal/version.Version=${version}"
        ];

        preBuild = ''
          rm -rf server/router/frontend/dist
          cp -r ${frontend} server/router/frontend/dist
        '';

        meta = {
          homepage = "https://usememos.com";
          description = "Lightweight, self-hosted memo hub";
          changelog = "https://github.com/usememos/memos/releases/tag/${src.rev}";
          license = lib.licenses.mit;
          mainProgram = "memos";
        };
      }
    ) { };
  };
}
