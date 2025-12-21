{ config, lib, pkgs, ... }:

{
  services.tailscale = {
    useRoutingFeatures = "server";
    extraUpFlags = [ "--advertise-exit-node" ];
  };

  # performance improvement
  services.networkd-dispatcher = {
    enable = true;
    rules."50-tailscale" = {
      onState = [ "routable" ];
      script = ''
        ${lib.getExe pkgs.ethtool} -K enp0s20f0u1 rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };
}