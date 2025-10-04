{ config, ... }:

{
  sops.secrets."vaultwarden/secrets.env".restartUnits = [ "vaultwarden.service" ];

  services.caddy.virtualHosts."vaultwarden.taild5f7e6.net".extraConfig =
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
    backupDir = "/var/backups/vaultwarden";
    config = {
      DOMAIN = "https://vaultwarden.taild5f7e6.ts.net";

      SIGNUPS_ALLOWED = false;
    };
    environmentFile = config.sops.secrets."vaultwarden/secrets.env".path;
  };
}
