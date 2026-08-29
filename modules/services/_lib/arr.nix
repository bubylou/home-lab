{
  config,
  lib,
  ...
}:
{
  arrOptions = name: port: {
    enable = lib.mkEnableOption "Enables the ${name} service";

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = port;
      example = 443;
    };
  };

  arrConfig =
    name:
    let
      cfg = config.home-lab.${name};
    in
    {
      services = {
        ${name} = {
          enable = true;
          settings = {
            server = {
              bindaddress = cfg.address;
              inherit (cfg) port;
            };
          };
        };
      };
    };
}
