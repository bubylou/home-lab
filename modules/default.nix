{ ... }:
{
  nixosModules.default = {
    imports = [
      ./qbitorrent.nix
      ./radarr.nix
      ./sonarr.nix
    ];
  };
}
