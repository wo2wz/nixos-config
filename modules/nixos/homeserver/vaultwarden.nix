{ config, ... }:

{
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
