{ config, ... }:

{
  services.caddy.virtualHosts."uptime-kuma.wo2wz.fyi".extraConfig =
    assert config.services.caddy.enable;
    ''
      import default-settings
      import cloudflare-tls

      reverse_proxy localhost:${config.services.uptime-kuma.settings.PORT}
    '';

  services.uptime-kuma = {
    enable = true;
    settings.PORT = "8005";
  };
}
