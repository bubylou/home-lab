{
  description = "Description for the project";

  outputs = {conflake, ...} @ inputs:
    conflake ./. {
      inherit inputs;
      packages = {
        default = pkgs: pkgs.vykar;
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
