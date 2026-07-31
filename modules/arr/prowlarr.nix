{
  flake.nixosModules.prowlarr =
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
          name = "prowlarr";
          port = 9696;
          inherit config lib;
        })
      ];
    };
}
