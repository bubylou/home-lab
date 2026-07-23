{ pkgs, ... }:
{
  packages = rec {
    default = quien;
    quien = pkgs.callPackage ./quien { };
  };
}
