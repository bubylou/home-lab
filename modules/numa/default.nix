{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.numa;
in {
  options.services.numa = {
    enable = lib.mkEnableOption "enable numa service";
    package = lib.mkPackageOption pkgs "numa" {};

    user = lib.mkOption {
      type = lib.types.str;
      default = "numa";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "numa";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 53;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        server = {
          bind_addr = "${cfg.address}:${toString cfg.port}";
          api_port = 5380;
        };

        cache = {
          max_entries = 100000;
          min_ttl = 60;
          max_ttl = 86400;
        };

        proxy = {
          enabled = true;
          port = 80;
          tls_port = 443;
          tld = "numa";
        };

        mobile.enabled = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.numa = {
      description = "Numa DNS — DNS you own, everywhere you go";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = ["${cfg.package}/bin/numa"];
        Restart = "always";
        RestartSec = 2;

        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;

        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";

        StateDirectory = "numa";
        StateDirectoryMode = "0750";
        ConfigurationDirectory = "numa";
        ConfigurationDirectoryMode = "0755";

        NoNewPrivileges = true;
        ProtectSystem = "strict";

        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";

        StandardOutput = "journal";
        StandardError = "journal";
        SyslogIdentifier = "numa";
      };
    };

    environment.etc."numa.toml".source = (pkgs.formats.toml {}).generate "numa.toml" cfg.settings;

    users.users = lib.mkIf (cfg.user == "numa") {
      numa = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "numa") {
      numa = {};
    };
  };
}
