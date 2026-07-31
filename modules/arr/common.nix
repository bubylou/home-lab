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
    enableStatus = lib.mkEnableOption "enables gatus status monitor";

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

      gatus.settings.endpoints = lib.mkIf cfg.enableStatus [
        {
          name = "${name}";
          url = "http://${cfg.address}:${toString cfg.port}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 100"
          ];
        }
      ];
    };
  };
}
