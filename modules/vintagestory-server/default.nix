{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.vintagestory-server;
  inherit (lib) mkIf mkOption types;
in {
  options.home-lab.vintagestory-server = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.vintagestory-server;
    };

    user = mkOption {
      type = types.str;
      default = "vintagestory";
    };

    group = mkOption {
      type = types.str;
      default = "vintagestory";
    };

    dataPath = mkOption {
      type = types.str;
      default = "/var/lib/vintagestory/data";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.vintagestory-server = {
      enable = true;
      description = "Vintage Story Server";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/vintagestory-server" "--dataPath" "${cfg.dataPath}";
        Restart = "on-failure";
        RestartSec = "10s";
        WorkingDirectory = cfg.dataPath;
      };
    };

    users.users = lib.mkIf (cfg.user == "vintagestory") {
      vintagestory = {
        inherit (cfg) group;
        home = cfg.dataPath;
        uid = config.ids.uids.vintagestory;
      };
    };

    users.groups = lib.mkIf (cfg.group == "vintagestory") {
      vintagestory = {
        gid = config.ids.gids.vintagestory;
      };
    };
  };
}
