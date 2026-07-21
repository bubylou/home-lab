{ ... }:
{
  nixosModules.default = {
    imports = [
      ./radarr.nix
      ./sonarr.nix
    ];
  };
}
