{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.home-lab.stump;
in {
  options = {
    home-lab.stump = with lib; {
      enable = mkEnableOption "stump";

      package = lib.mkPackageOption pkgs "stump" {};

      environment = lib.mkOption {
        default = {};
        type = lib.types.attrsOf lib.types.str;
        example = lib.literalExpression ''
          {
            STUMP_PORT = "10801";
          }
        '';
        description = "stump environment variables";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "stump";
        description = ''
          User account under which Stump runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "stump";
        description = ''
          Group under which Stump runs.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.stump = {
      enable = true;
      description = "A free and open source comics, manga and digital book server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/stump";
        Restart = "on-failure";
        StateDirectory = "stump";
        WorkingDirectory = "/var/lib/stump";
        RuntimeDirectory = "stump";
      };

      environment =
        {
          STUMP_CONFIG_DIR = "config";
          STUMP_DB_PATH = ".";
          STUMP_PRETTY_LOGS = "false";
        }
        // cfg.environment;
    };

    users.users = lib.mkIf (cfg.user == "stump") {
      stump = {
        inherit (cfg) group;
        home = "/var/lib/stump";
        uid = config.ids.uids.stump;
      };
    };

    users.groups = lib.mkIf (cfg.group == "stump") {
      stump = {
        gid = config.ids.gids.stump;
      };
    };
  };
}
