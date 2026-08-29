{
  flake.nixosModules.sonarr =
    {
      config,
      lib,
      ...
    }:
    let
      arr = import ./_lib/arr.nix { inherit config lib; };
      cfg = config.home-lab.sonarr;
    in
    {
      options.home-lab.sonarr = arr.arrOptions "sonarr" 8989;
      config = lib.mkIf cfg.enable (arr.arrConfig "sonarr");
    };
}
