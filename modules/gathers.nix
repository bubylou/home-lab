{
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  perSystem = { pkgs, lib, ... }: rec {
    checks.gathers-api = packages.gathers;
    packages =
      let
        pname = "gathers";
        version = "0.5";
        src = pkgs.fetchFromGitHub {
          owner = "morosanmihail";
          repo = pname;
          tag = "v${version}";
          hash = "sha256-N4XTdKzJ22VTt5rUJGaASlTUkDomRJYUeeKBOQocd4w=";
        };

        meta = {
          description = "Find and collect cards from your favourite card games!";
          homepage = "https://www.gathers.cards";
          license = lib.licenses.mit;
        };

      in
      {
        gathers-api = pkgs.callPackage (
          {
            sqlite,
            rustPlatform,
            fetchFromGitHub,
            cacert,
            ...
          }:
          rustPlatform.buildRustPackage {
            inherit
              pname
              version
              src
              meta
              ;

            name = "gathers-api";
            cargoLock.lockFile = src + /Cargo.lock;

            buildInputs = [
              cacert
              sqlite
            ];
          }
        ) { };
      };
  };
}
