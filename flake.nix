{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
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
          unpackerr = pkgs.callPackage ./packages/unpackerr {};
          vintagestory = pkgs.callPackage ./packages/vintagestory {};
          vintagestory-wayland = pkgs.callPackage ./packages/vintagestory {
            inherit (pkgs) libxkbcommon wayland;
            x11Support = false;
            waylandSupport = true;
          };
        };

        checks = {
          inherit (self.packages.${system}) quien;
          inherit (self.packages.${system}) stump;
          inherit (self.packages.${system}) unpackerr;
          inherit (self.packages.${system}) vintagestory;
          inherit (self.packages.${system}) vintagestory-wayland;
        };

        apps = rec {
          default = quien;
          quien = flake-utils.lib.mkApp {drv = self.packages.${system}.quien;};
          stump = flake-utils.lib.mkApp {drv = self.packages.${system}.stump;};
          unpackerr = flake-utils.lib.mkApp {drv = self.packages.${system}.unpackerr;};
          vintagestory = flake-utils.lib.mkApp {drv = self.packages.${system}.vintagestory;};
          vintagestory-wayland = flake-utils.lib.mkApp {drv = self.packages.${system}.vintagestory-wayland;};
        };
      }
    );
}
