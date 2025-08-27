{ config, ... }:

{
  users.users.zipline = {
    group = "zipline";
    isSystemUser = true;
  };
  users.groups.zipline = {};
  services.zipline = {
    enable = true;
    settings = {
      CORE_PORT = 8001;

      FEATURES_VERSION_CHECKING = "false";
      FEATURES_THUMBNAILS_NUM_THREADS = 2;
    };
    environmentFiles = [ config.sops.secrets."zipline/secrets.env".path ];
  };
}