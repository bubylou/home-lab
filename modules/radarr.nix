{
  config,
  lib,
  ...
}:
let
  cfg = config.home-lab.radarr;
in
{
  options.home-lab.radarr = {
    enable = lib.mkEnableOption "enables Radarr service";

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 7878;
      example = 443;
    };

    disableAuth = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.radarr = {
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
