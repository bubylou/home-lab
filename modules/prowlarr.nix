{
  config,
  lib,
  ...
}:
let
  cfg = config.home-lab.prowlarr;
in
{
  imports = [
    (import ./common/arr.nix {
      name = "prowlarr";
      port = 9696;
      inherit config lib;
    })
  ];
}
