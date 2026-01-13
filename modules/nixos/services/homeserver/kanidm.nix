{ config, pkgs, lib, ... }:

{
  sops.secrets = {
    "acme/secrets.env" = {};
  }
  // lib.genAttrs [
    "kanidm/oauth2/grafana"
    "kanidm/oauth2/jellyfin"
    "kanidm/oauth2/nextcloud"
    "kanidm/oauth2/vaultwarden"
  ]
  (x: {
    owner = "kanidm";
    group = "kanidm";
  });

  users.groups.tls-kanidm.members = [ "caddy" "kanidm" ];

  security.acme = {
    acceptTerms = true;

    certs."kanidm.wo2wz.fyi" = {
      environmentFile = config.sops.secrets."acme/secrets.env".path;
      email = "189177184+wo2wz@users.noreply.github.com";
      dnsProvider = "cloudflare";

      group = "tls-kanidm";
      reloadServices = [ "caddy.service" "kanidm.service" ];
    };
  };

  services.caddy.virtualHosts."kanidm.wo2wz.fyi".extraConfig =
  assert config.services.caddy.enable;
  ''
    import default-settings
    import cloudflare-tls

    reverse_proxy https://localhost:8004 {
        header_up Host {upstream_hostport}
        transport http {
            tls_server_name kanidm.wo2wz.fyi
            tls_client_auth ${config.security.acme.certs."kanidm.wo2wz.fyi".directory}/fullchain.pem ${config.security.acme.certs."kanidm.wo2wz.fyi".directory}/key.pem
        }
    }
  '';

  services.kanidm = {
    enableServer = true;
    package = pkgs.kanidmWithSecretProvisioning_1_8;

    serverSettings = {
      version = "2";

      bindaddress = "127.0.0.1:8004";
      domain = "kanidm.wo2wz.fyi";
      origin = "https://kanidm.wo2wz.fyi";
      tls_chain = "${config.security.acme.certs."kanidm.wo2wz.fyi".directory}/fullchain.pem";
      tls_key = "${config.security.acme.certs."kanidm.wo2wz.fyi".directory}/key.pem";
      http_client_address_info.x-forward-for = [ "127.0.0.1" "::1" ];
    };

    provision = {
      enable = true;

      persons.wo2w = {
        displayName = "wo2w";
        legalName = "Wo2wz_";
        mailAddresses = [ "wo2w@kanidm.wo2wz.fyi" ];

        groups = [
          "grafana_users"
          "jellyfin_users"
          "nextcloud_users"
          "vaultwarden_users"

          "grafana_admins"
          "jellyfin_admins"
        ];
      };

      groups = lib.genAttrs [
        "grafana_users"
        "jellyfin_users"
        "nextcloud_users"
        "vaultwarden_users"
      ] (x: {})
      // {
        grafana_admins.members = [ "grafana_users" ];
        jellyfin_admins.members = [ "jellyfin_users" ];
      };

      systems.oauth2 = {
        grafana = {
          displayName = "Grafana";
          originUrl = "https://grafana.taild5f7e6.ts.net/login/generic_oauth";
          originLanding = "https://grafana.taild5f7e6.ts.net";

          preferShortUsername = true;
          basicSecretFile = config.sops.secrets."kanidm/oauth2/grafana".path;
          scopeMaps.grafana_users = [ "openid" "email" "profile" "groups" "offline_access" ];
          claimMaps.grafana_users.valuesByGroup.grafana_admins = [ "GrafanaAdmin" ];
        };

        jellyfin = {
          displayName = "Jellyfin";
          originUrl = "https://jellyfin.taild5f7e6.ts.net/sso/OID/redirect/Kanidm";
          originLanding = "https://jellyfin.taild5f7e6.ts.net";

          preferShortUsername = true;
          basicSecretFile = config.sops.secrets."kanidm/oauth2/jellyfin".path;
          scopeMaps.jellyfin_users = [ "openid" "profile" "groups" ];
          claimMaps.grafana_users.valuesByGroup.jellyfin_admins = [ "JellyfinAdmin" ];
        };

        nextcloud = {
          displayName = "Nextcloud";
          originUrl = "https://nextcloud.wo2wz.fyi/index.php/apps/user_oidc/code";
          originLanding = "https://nextcloud.wo2wz.fyi/index.php";

          preferShortUsername = true;
          basicSecretFile = config.sops.secrets."kanidm/oauth2/nextcloud".path;
          scopeMaps.nextcloud_users = [ "openid" "profile" ];
        };
        
        vaultwarden = {
          displayName = "Vaultwarden";
          originUrl = "https://vaultwarden.taild5f7e6.ts.net/identity/connect/oidc-signin";
          originLanding = "https://vaultwarden.taild5f7e6.ts.net";

          preferShortUsername = true;
          basicSecretFile = config.sops.secrets."kanidm/oauth2/vaultwarden".path;
          scopeMaps.vaultwarden_users = [ "openid" "email" "profile" "offline_access" ];
        };
      };
    };

    enableClient = true;
    clientSettings.uri = "https://kanidm.wo2wz.fyi";
  };
}
