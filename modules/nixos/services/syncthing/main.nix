{ config, ... }:

{
  services.syncthing = {
    user = "wo2w";
    dataDir = "/home/wo2w";
    settings = {
      folders = {
        minecraft-instances = {
          path = "~/.local/share/PrismLauncher/instances";
          devices = [
            "drone"
            "earthmover"
            "swordsmachine"
          ];
        };

        terraria = {
          path = "~/.local/share/Terraria";
          devices = [
            "drone"
            "earthmover"
            "swordsmachine"
          ];
        };
      };
    };
  };
}