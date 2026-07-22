{ ... }:
{
  nixosModules.default = {
    imports = [
      ./caddy.nix
      ./radarr.nix
      ./sonarr.nix
    ];
  };
}
