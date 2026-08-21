{
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  perSystem = { pkgs, lib, ... }: rec {
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

    checks = {
      gathers-api = packages.gathers-api;
    };

    apps = {
      gathers-api = {
        type = "app";
        program = "${packages.gathers-api}/bin/server";
        meta = packages.gathers-api.meta;
      };

      gathers-cli = {
        type = "app";
        program = "${packages.gathers-api}/bin/gathers";
        meta = packages.gathers-api.meta;
      };
    };
  };
}
