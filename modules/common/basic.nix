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
    enableProxy = lib.mkEnableOption "enables caddy proxy";

    url = lib.mkOption {
      type = lib.types.str;
      default = "${name}.${config.home-lab.caddy.domain}";
      example = "example.com";
    };

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

  config = lib.mkIf cfg.enableProxy {
    services = {
      caddy = {
        enable = true;
        virtualHosts."${cfg.url}" = {
          useACMEHost = config.home-lab.caddy.domain;
          extraConfig = lib.mkDefault ''
            reverse_proxy http://${cfg.address}:${toString cfg.port}
          '';
        };
      };
    };
  };
}
