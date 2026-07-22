{ ... }:
{
  nixosModules.default = {
    imports = [
      ./prowlarr.nix
      ./radarr.nix
      ./sonarr.nix
    ];
  };
}
