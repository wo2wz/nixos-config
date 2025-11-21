{ config, lib, pkgs, ... }:

{
  services.tailscale = {
    useRoutingFeatures = "server";
    extraUpFlags = [ "--advertise-exit-node" ];
  };

  # performance improvement
  environment.systemPackages = [ pkgs.ethtool ];
  services.networkd-dispatcher = {
    enable = true;
    rules."50-tailscale" = {
      onState = [ "routable" ];
      script = ''
        ${lib.getExe pkgs.ethtool} -K eth0 rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };
}