{
  flake.nixosModules.bazarr =
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
          name = "bazarr";
          port = 6767;
          inherit config lib;
        })
      ];
    };
}
