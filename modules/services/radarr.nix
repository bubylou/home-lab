{
  flake.nixosModules.radarr =
    {
      config,
      lib,
      ...
    }:
    let
      arr = import ./_lib/arr.nix { inherit config lib; };
      cfg = config.home-lab.radarr;
    in
    {
      options.home-lab.radarr = arr.arrOptions "Radarr" 7878;
      config = lib.mkIf cfg.enable (arr.arrConfig "radarr");
    };
}
