{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.vintagestory-server;
  inherit (lib) mkIf mkOption types;
in {
  options.vintagestory-server = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the Vintage Story server";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.vintagestory-server;
      description = "The Vintage Story server package to use";
    };

    user = mkOption {
      type = types.str;
      default = "vintagestory";
      description = "The user to run the Vintage Story server as";
    };

    group = mkOption {
      type = types.str;
      default = "vintagestory";
      description = "The group to run the Vintage Story server as";
    };

    dataPath = mkOption {
      type = types.str;
      default = "/var/lib/vintagestory/data";
      description = "The path to the Vintage Story server data directory";
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
