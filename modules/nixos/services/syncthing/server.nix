{ config, ... }:

{
  services.syncthing.settings.folders = {
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
}