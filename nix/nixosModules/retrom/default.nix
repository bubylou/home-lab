{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.retrom;
in {
  options.home-lab.retrom = {
    enable = lib.mkEnableOption "Enable Retrom service.";

    package = lib.mkPackageOption pkgs "retrom" {};

    user = lib.mkOption {
      type = lib.types.str;
      default = "retrom";
      description = "User to use for retrom systemd service.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "retrom";
      description = "Group to use for retrom systemd service.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/retrom";
      description = "Directory to store service data";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.retrom = {
      description = "Retrom Service";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "on-failure";
        StateDirectory = "retrom";
        RuntimeDirectory = "retrom";
        WorkingDirectory = cfg.dataDir;
        Environment = [
          "RETROM_DATA_DIR=${cfg.dataDir}"
        ];
      };
    };

    users.users = lib.mkIf (cfg.user == "retrom") {
      retrom = {
        inherit (cfg) group;
        home = cfg.dataDir;
        uid = config.ids.uids.retrom;
        createHome = true;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "retrom") {
      retrom = {
        gid = config.ids.gids.retrom;
      };
    };
  };
}
