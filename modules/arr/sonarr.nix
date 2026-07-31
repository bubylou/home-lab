{
  flake.nixosModules.sonarr =
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
          name = "sonarr";
          port = 8989;
          inherit config lib;
        })
      ];
    };
}
