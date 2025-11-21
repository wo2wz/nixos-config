{ config, ... }:

{
  services.tailscale = {
    useRoutingFeatures = "client";
    extraUpFlags = [ "--exit-node-allow-lan-access=true" ];
  };
}