{ pkgs, ... }:
{
  packages = rec {
    default = vintagestory;
    vintagestory = pkgs.callPackage ./vintagestory { };
  };
}
