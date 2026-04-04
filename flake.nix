{
  description = "Description for the project";

  outputs = {conflake, ...} @ inputs:
    conflake ./. {
      inherit inputs;
      checks = {
        lidarr = pkgs: pkgs.lidarr;
        radarr = pkgs: pkgs.radarr;
        retrom = pkgs: pkgs.retrom;
        prowlarr = pkgs: pkgs.prowlarr;
        sonarr = pkgs: pkgs.sonarr;
        unpackerr = pkgs: pkgs.unpackerr;
        vykar = pkgs: pkgs.vykar;
      };
    };

  inputs = {
    conflake = {
      url = "github:ratson/conflake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
}
