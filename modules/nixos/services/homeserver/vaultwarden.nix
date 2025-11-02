{ config, ... }:

{
  sops.secrets."vaultwarden/secrets.env".restartUnits = [ "vaultwarden.service" ];

  services.caddy.virtualHosts."vaultwarden.taild5f7e6.ts.net".extraConfig =
    assert config.services.caddy.enable;
    ''
      import default-settings

      bind tailscale/vaultwarden

      # block connections to admin login
      respond /admin/* 403

      reverse_proxy localhost:8000
    '';

  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://vaultwarden.taild5f7e6.ts.net";
      IP_HEADER = "X-Forwarded-For";

      SIGNUPS_ALLOWED = false;

      TRASH_AUTO_DELETE_DAYS = 30;
    };
    environmentFile = config.sops.secrets."vaultwarden/secrets.env".path;
  };
}
