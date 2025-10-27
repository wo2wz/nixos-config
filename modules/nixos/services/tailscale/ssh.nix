{ config, ... }:

{
  services.tailscale.extraUpFlags = [ "--ssh" ];
}