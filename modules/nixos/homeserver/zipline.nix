{ config, ... }:

{
  services.zipline = {
    enable = true;
    settings = {
      FEATURES_VERSION_CHECKING = "false";
      FEATURES_THUMBNAILS_NUM_THREADS = 2;
    };
    environmentFiles = [ config.sops.secrets."zipline/secrets.env".path ];
  };
}