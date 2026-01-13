{ config, ... }:

{
  services.caddy.virtualHosts."technitium.taild5f7e6.ts.net".extraConfig =
  assert config.services.caddy.enable;  
  ''
    import default-settings

    bind tailscale/technitium

    reverse_proxy localhost:5380
    reverse_proxy /dns-query localhost:8053
  '';

  services.technitium-dns-server.enable = true;
}