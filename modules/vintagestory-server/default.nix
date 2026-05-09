{
  self,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.vintagestory-server;
  pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.package.vintagestory-server;
in {
  options.home-lab.vintagestory-server = {
    enable = lib.mkEnableOption "Vintagestory server";
    package = lib.mkPackageOption pkg {};

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
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "vintagestory") {
      vintagestory = {};
    };
  };
}
