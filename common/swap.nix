{ config, ... }:

{
  swapDevices = [ {
    device = "/var/swapfile";
    size = 16*1024;
  } ];
}