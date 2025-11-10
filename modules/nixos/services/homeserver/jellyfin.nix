{ config, pkgs, ... }:

{
  services.caddy.virtualHosts."jellyfin.taild5f7e6.ts.net".extraConfig = ''
    import default-settings

    bind tailscale/jellyfin

    reverse_proxy localhost:8007
  '';

  services.jellyfin.enable = true;
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}
