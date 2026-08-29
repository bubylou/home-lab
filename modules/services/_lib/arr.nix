{
  config,
  lib,
  ...
}:
{
  arrOptions = name: port: {
    enable = lib.mkEnableOption "Enables the ${name} service";
    disableAuth = lib.mkEnableOption "Disables built-in authentication";

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

    proxy = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Enables reverse proxy";

          domain = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
            example = "example.com";
          };

          server = lib.mkOption {
            type = lib.types.enum [ "caddy" ];
            default = "caddy";
            example = "";
          };
        };
      };
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

            auth = lib.mkIf (cfg.proxy.enable && cfg.disableAuth) {
              authenticationrequired = "DisabledForLocalAddresses";
              method = "External";
            };
          };
        };

        caddy = lib.mkIf (cfg.proxy.server == "caddy") {
          enable = lib.mkIf cfg.proxy.enable true;

          virtualHosts."${name}.${cfg.proxy.domain}".extraConfig = ''
            reverse_proxy http://${cfg.address}:${toString cfg.port}
          '';
        };
      };
    };
}
