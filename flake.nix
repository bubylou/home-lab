{
  inputs = {
    import-tree.url = "github:denful/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
