{
  name,
  port,
  config,
  lib,
  ...
}:
let
  cfg = config.home-lab.${name};
in
{
  imports = [
    (import ./basic.nix {
      inherit
        name
        port
        config
        lib
        ;
    })
  ];

  options.home-lab.${name} = {
    disableAuth = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.${name} = {
      enable = true;
      settings = {
        server = {
          bindaddress = cfg.address;
          inherit (cfg) port;
        };

        auth = lib.mkIf cfg.disableAuth {
          enabled = false;
          method = "External";
          authenticationrequired = false;
        };
      };
    };
  };
}
