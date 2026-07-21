{
  config,
  lib,
  ...
}:
let
  cfg = config.home-lab.sonarr;
in
{
  imports = [
    (import ./common/arr.nix {
      name = "sonarr";
      port = 8989;
      inherit config lib;
    })
  ];
}
