{
  flake.nixosModules.lidarr =
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
          name = "lidarr";
          port = 8686;
          inherit config lib;
        })
      ];
    };
}
