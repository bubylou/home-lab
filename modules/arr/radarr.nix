{
  flake.nixosModules.radarr =
    {
      config,
      self',
      inputs',
      lib,
      pkgs,
      system,
      ...
    }:
    {
      imports = [
        (import ./common.nix {
          name = "radarr";
          port = 7878;
          inherit config lib;
        })
      ];
    };
}
