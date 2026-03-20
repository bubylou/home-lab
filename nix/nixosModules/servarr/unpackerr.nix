{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.unpackerr;
in {
  options = {
    services.unpackerr = {
      enable = lib.mkEnableOption "Unpackerr, archive extraction daemon";

      package = lib.mkPackageOption pkgs "unpackerr" {};

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the Unpackerr web interface.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "unpackerr";
        description = "User account under which Unpackerr runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "unpackerr";
        description = "Group under which Unpackerr runs.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-unpackerr".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.unpackerr = {
      description = "Unpackerr";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = "${cfg.package}/bin/unpackerr";
        Restart = "on-failure";
        RestartSec = "10";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [cfg.settings.server.port];
    };

    users.users = lib.mkIf (cfg.user == "unpackerr") {
      unpackerr = {
        inherit (cfg) group;
        home = cfg.dataDir;
        uid = config.ids.uids.unpackerr;
      };
    };

    users.groups = lib.mkIf (cfg.group == "unpackerr") {
      unpackerr.gid = config.ids.gids.unpackerr;
    };
  };
}
