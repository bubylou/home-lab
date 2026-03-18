{
  importNpmLock,
  fetchFromGitHub,
  buildNpmPackage,
  buildGoModule,
}: let
  frontend = buildNpmPackage rec {
    pname = "frontend";
    version = "0.1.40";

    src = fetchFromGitHub {
      owner = "donetick";
      repo = "${pname}";
      tag = "v${version}";
      hash = "sha256-u4LX7pdG1AXap9leOX8YTMRQELjakCV/5mLnpKK039U=";
    };

    npmDeps = importNpmLock {npmRoot = src;};
    inherit (importNpmLock) npmConfigHook;
    npmBuildScript = "build-selfhosted";
  };
in
  buildGoModule (finalAttrs: {
    pname = "donetick";
    version = "0.1.74";

    src = fetchFromGitHub {
      owner = "donetick";
      repo = "${finalAttrs.pname}";
      tag = "v${finalAttrs.version}";
      hash = "sha256-zdHdHjPQKoKJjgjan/nT1JhQoQ0xrytX5oVVwSE7IeM=";
    };

    vendorHash = "sha256-ATcGlLgCydADw2w6/WCle9Mvxe79Px2OC+63N6kmSPA=";

    ldflags = [
      "-X main.version=${finalAttrs.version}"
      "-w"
      "-s"
    ];

    prePatch = ''
      cp -r ${frontend}/dist ./frontend
    '';
  })
