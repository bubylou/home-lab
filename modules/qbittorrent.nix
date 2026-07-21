{
  config,
  lib,
  ...
}:
let
  cfg = config.home-lab.qbittorrent;
in
{
  imports = [
    (import ./common/basic.nix {
      name = "qbittorrent";
      port = 8080;
      inherit config lib;
    })
  ];

  config = lib.mkIf cfg.enable {
    services.qbittorrent = {
      enable = true;
      webuiPort = cfg.port;
      extraArgs = [ "--confirm-legal-notice" ];
    };
  };
}
