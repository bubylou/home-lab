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
    enableProxy = lib.mkEnableOption "enables caddy reverse proxy";

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

    url = lib.mkOption {
      type = lib.types.str;
      default = "${name}.${config.home-lab.domain}";
      example = "example.com";
    };
  };

  config = lib.mkIf cfg.enable {
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

      caddy = lib.mkIf cfg.enableProxy {
        virtualHosts."${cfg.url}" = {
          extraConfig = lib.mkDefault ''
            reverse_proxy http://${cfg.address}:${toString cfg.port}
          '';
        };
      };
    };
  };
}
