{ config, lib, ... }:
let

  cfg = config.home-lab.caddy;
in
{
  options.home-lab.caddy = {
    enable = lib.mkEnableOption "enables caddy service";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "example.com";
    };

    email = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "user@example.com";
    };

    dnsProvider = lib.mkOption {
      type = lib.types.str;
      default = "cloudflare";
      example = "gcloud";
    };

    dnsResolver = lib.mkOption {
      type = lib.types.str;
      default = "1.1.1.1:53";
      example = "8.8.8.8:53";
    };

    credentialFiles = lib.mkOption {
      type = lib.types.attrsOf (lib.types.path);
      default = { };
      example = {
        "CLOUDFLARE_API_KEY_FILE" = "/run/keys/cloudflare-api";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      caddy = {
        enable = true;
        globalConfig = ''
          auto_https off
          servers {
            trusted_proxies static private_ranges
          }
        '';

        virtualHosts.${cfg.domain} = {
          useACMEHost = cfg.domain;
          extraConfig = ''
            respond OK
          '';
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.email;

      certs."${cfg.domain}" = {
        inherit (config.services.caddy) group;
        inherit (cfg)
          credentialFiles
          domain
          dnsProvider
          dnsResolver
          ;
        extraDomainNames = [ "*.${cfg.domain}" ];
        dnsPropagationCheck = true;
      };
    };
  };
}
