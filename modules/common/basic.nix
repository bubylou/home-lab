{
  name,
  port,
  lib,
  config,
  ...
}:
let
  cfg = config.home-lab.${name};
in
{
  options.home-lab.${name} = {
    enable = lib.mkEnableOption "enables ${name} service";

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
}
