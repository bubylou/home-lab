{
  description = "Description for the project";

  outputs = {conflake, ...} @ inputs:
    conflake ./. {
      inherit inputs;
      checks = {
        radarr = pkgs: pkgs.radarr;
        prowlarr = pkgs: pkgs.prowlarr;
        sonarr = pkgs: pkgs.sonarr;
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
