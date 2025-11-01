{ config, ... }:

{
  sops.secrets."zipline/secrets.env".restartUnits = [ "zipline.service" ];

  services.caddy.virtualHosts."zipline.wo2wz.fyi".extraConfig =
    assert config.services.caddy.enable;
    ''
      import default-settings
      import cloudflare-tls

      reverse_proxy localhost:8001
    '';

  users.users.zipline = {
    group = "zipline";
    isSystemUser = true;
  };
  users.groups.zipline = {};

  services.zipline = {
    enable = true;
    settings = {
      CORE_PORT = 8001;
      DATASOURCE_LOCAL_DIRECTORY = "/mnt/external/storage/zipline/uploads";

      FEATURES_VERSION_CHECKING = "false";
      FEATURES_THUMBNAILS_NUM_THREADS = 2;
      FEATURES_OAUTH_REGISTRATION = "true";
    };
    environmentFiles = [ config.sops.secrets."zipline/secrets.env".path ];
  };
}
