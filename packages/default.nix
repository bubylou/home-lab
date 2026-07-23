{ pkgs, ... }:
rec {
  packages = rec {
    default = quien;
    quien = pkgs.callPackage ./quien { };
  };

  checks = {
    quien = packages.quien;
  };
}
