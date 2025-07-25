{ hostName, config, ... }:

{
  networking = {
    networkmanager.enable = true;
    hostName = "${hostName}";
  };
}