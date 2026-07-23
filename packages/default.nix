{ pkgs, ... }:
{
  packages = rec {
    default = vintagestory;
    vintagestory = pkgs.callPackage ./vintagestory { };
    vintagestory-server = pkgs.callPackage ./vintagestory/server-only.nix { };
  };
}
