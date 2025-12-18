{ config, ... }:

{
  sops.secrets = {
    "syncthing/cert.pem" = {};
    "syncthing/key.pem" = {};
  };

  services.syncthing = {
    cert = config.sops.secrets."syncthing/cert.pem".path;
    key = config.sops.secrets."syncthing/key.pem".path;

    settings.folders = {
      minecraft-instances = {
        path = "${config.services.syncthing.dataDir}/minecraft-instances";
        type = "receiveonly";
        devices = [
          "drone"
          "earthmover"
          "swordsmachine"
        ];
      };

      terraria = {
        path = "${config.services.syncthing.dataDir}/terraria";
        type = "receiveonly";
        devices = [
          "drone"
          "earthmover"
          "swordsmachine"
        ];
      };
    };
  };
}