{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.vintagestory-server;
in {
  options.services.vintagestory-server = {
    enable = lib.mkEnableOption "Vintagestory server";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.vintagestory-server;
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "vintagestory";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "vintagestory";
    };

    dataPath = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/vintagestory/data";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.vintagestory-server = {
      description = "Vintage Story Server";
      after = ["network.target"];
      wants = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;

        ExecStart = ["${cfg.package}/bin/vintagestory-server" "--dataPath" "${cfg.dataPath}"];
        Restart = "on-failure";
        RestartSec = "10s";
        WorkingDirectory = cfg.dataPath;

        StandardOutput = "journal";
        StandardError = "journal";
        SyslogIdentifier = "vintagestory-server";
      };
    };

    users.users = lib.mkIf (cfg.user == "vintagestory") {
      vintagestory = {
        inherit (cfg) group;
        home = cfg.dataPath;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "vintagestory") {
      vintagestory = {};
    };
  };
}
