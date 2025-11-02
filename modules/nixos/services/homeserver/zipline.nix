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
      CORE_DEFAULT_DOMAIN = "zipline.wo2wz.fyi";
      CORE_PORT = 8001;
      CORE_TRUST_PROXY = "true";
      CORE_RETURN_HTTPS_URLS = "true";

      DATASOURCE_LOCAL_DIRECTORY = "/mnt/external/storage/zipline/uploads";

      FEATURES_VERSION_CHECKING = "false";
      FEATURES_THUMBNAILS_NUM_THREADS = 2;
      FEATURES_ROBOTS_TXT = "false";
      INVITES_ENABLED = "false";

      MFA_TOTP_ENABLED = "true";
      MFA_PASSKEYS = "true";

      FEATURES_OAUTH_REGISTRATION = "true";
      OAUTH_BYPASS_LOCAL_LOGIN = "true";
      OAUTH_OIDC_CLIENT_ID = "zipline";
      OAUTH_OIDC_AUTHORIZE_URL = "https://kanidm.wo2wz.fyi/ui/oauth2";
      OAUTH_OIDC_USERINFO_URL = "https://kanidm.wo2wz.fyi/oauth2/openid/zipline/userinfo";
      OAUTH_OIDC_TOKEN_URL = "https://kanidm.wo2wz.fyi/oauth2/token";

      FILES_MAX_FILE_SIZE = "3091283091716487142128741263894122347014687124687124614791824619246129491246128461841279468127468912461924612974182746182468712468126487912648126481256487126491672941974612945618274610289417846192849712471eb";
      FILES_ASSUME_MIMETYPES = "true";
      FILES_REMOVE_GPS_METADATA = "true";
    };
    environmentFiles = [ config.sops.secrets."zipline/secrets.env".path ];
  };
}
