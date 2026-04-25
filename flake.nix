{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    skia-binaries-x86_64-linux = {
      type = "file";
      url = "https://github.com/rust-skia/skia-binaries/releases/download/0.90.0/skia-binaries-da4579b39b75fa2187c5-x86_64-unknown-linux-gnu-gl-pdf-textlayout-vulkan.tar.gz";
      flake = false;
    };

    skia-binaries-aarch64-linux = {
      type = "file";
      url = "https://github.com/rust-skia/skia-binaries/releases/download/0.90.0/skia-binaries-da4579b39b75fa2187c5-aarch64-unknown-linux-gnu-gl-pdf-textlayout-vulkan.tar.gz";
      flake = false;
    };

    skia-binaries-aarch64-darwin = {
      type = "file";
      url = "https://github.com/rust-skia/skia-binaries/releases/download/0.90.0/skia-binaries-da4579b39b75fa2187c5-aarch64-apple-darwin-gl-pdf-textlayout-vulkan.tar.gz";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };
      in {
        packages = rec {
          default = quien;
          quien = pkgs.callPackage ./packages/quien {};
          stump = pkgs.callPackage ./packages/stump {};

          vintagestory = pkgs.callPackage ./packages/vintagestory {};
          vintagestory-wayland = pkgs.callPackage ./packages/vintagestory {
            inherit (pkgs) libxkbcommon wayland;
            x11Support = false;
            waylandSupport = true;
          };

          vykar = pkgs.callPackage ./packages/vykar {inherit inputs;};
        };

        checks = {
          inherit (self.packages.${system}) quien;
          inherit (self.packages.${system}) stump;
          inherit (self.packages.${system}) vintagestory;
          inherit (self.packages.${system}) vintagestory-wayland;
          inherit (self.packages.${system}) vykar;
        };

        apps = rec {
          default = quien;
          quien = flake-utils.lib.mkApp {drv = self.packages.${system}.quien;};
          stump = flake-utils.lib.mkApp {drv = self.packages.${system}.stump;};

          vintagestory = flake-utils.lib.mkApp {drv = self.packages.${system}.vintagestory;};
          vintagestory-wayland = flake-utils.lib.mkApp {drv = self.packages.${system}.vintagestory-wayland;};

          vykar-cli = flake-utils.lib.mkApp {drv = self.packages.${system}.vykar;};
          vykar-gui = flake-utils.lib.mkApp {
            drv = self.packages.${system}.vykar;
            exePath = "/bin/vykar-gui";
          };
          vykar-server = flake-utils.lib.mkApp {
            drv = self.packages.${system}.vykar;
            exePath = "/bin/vykar-server";
          };
        };
      }
    );
}
