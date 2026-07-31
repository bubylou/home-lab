{
  perSystem =
    {
      config,
      self',
      inputs',
      pkgs,
      system,
      ...
    }:
    {
      checks.aliasvault = self'.packages.aliasvault;
      packages.aliasvault =
        let
          inherit (pkgs)
            wasm-pack
            rustPlatform
            fetchFromGitHub
            dotnetCorePackages
            buildNpmPackage
            buildDotnetModule
            ;

          pname = "aliasvault";
          version = "0.30.2";
          src = fetchFromGitHub {
            owner = pname;
            repo = pname;
            tag = version;
            hash = "sha256-I4EN2cr1m57s7p9IIm08YoSo874mSdYA4Jid033GQ+M=";
          };

          models = buildNpmPackage {
            inherit pname version;
            src = src + "/core/models";
            npmDepsHash = "sha256-1aOZK2izN0e6THTfgo941UV8UZ0dUs/z0jrAgokjcvo=";

          };

          vault = buildNpmPackage {
            inherit pname version;
            src = src + "/core/vault";
            npmDepsHash = "sha256-aSTE8TWUfJI1hl4USO3jAAbIwTWKfn+hhVy8INIMOTg=";
          };

          core = rustPlatform.buildRustPackage {
            inherit pname version;
            src = src + "/core/rust";
            cargoHash = "sha256-3QnvnD/HNct93qyi/oSaZV1RfTshOjFO7IwSlMG52zk=";

            nativeBuildInputs = [
              wasm-pack
            ];
          };
        in
        buildDotnetModule {
          inherit pname version;
          src = src + "/apps/server";
          projectFile = "aliasvault.sln";

          buildInputs = [
            core
            models
            vault
          ];

          dotnet-sdk = dotnetCorePackages.sdk_10_0;
          dotnet-runtime = dotnetCorePackages.runtime_10_0;
          packNupkg = true;
        };
    };
}
