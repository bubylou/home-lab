{
  description = "Description for the project";

  outputs = {conflake, ...} @ inputs:
    conflake ./. {
      inherit inputs;

      apps = {
        autopulse,
        vykar,
        ...
      }: {
        autopulse = "${autopulse}/bin/autopulse";
        vykar = "${vykar}/bin/vykar";
        vykar-gui = "${vykar}/bin/vykar-gui";
        vykar-server = "${vykar}/bin/vykar-server";
      };

      checks = {
        autopulse = pkgs: pkgs.autopulse;
        vykar = pkgs: pkgs.vykar;
      };

      devShell.packages = pkgs: [pkgs.rustfmt pkgs.nixfmt];
      formatters = {
        "*.nix" = "nixfmt";
        "*.rs" = "rustfmt";
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
