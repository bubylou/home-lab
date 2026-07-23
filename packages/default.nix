{ pkgs, ... }:
rec {
  packages = rec {
    default = vintagestory;
    vintagestory = pkgs.callPackage ./vintagestory { };
    vintagestory-server = pkgs.callPackage ./vintagestory/server-only.nix { };
  };

  checks = {
    vintagestory = packages.vintagestory;
    vintagestory-server = packages.vintagestory-server;
  };
}
