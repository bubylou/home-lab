{
  flake.nixosModules.prowlarr =
    {
      config,
      lib,
      ...
    }:
    let
      arr = import ./_lib/arr.nix { inherit config lib; };
      cfg = config.home-lab.prowlarr;
    in
    {
      options.home-lab.prowlarr = arr.arrOptions "Prowlarr" 9696;
      config = lib.mkIf cfg.enable (arr.arrConfig "prowlarr");
    };
}
