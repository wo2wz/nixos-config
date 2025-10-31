{ config, pkgs, lib, ... }:

{
  sops.secrets = {
    "acme/secrets.env" = {};

    "kanidm/oauth2/nextcloud" = {
      owner = "kanidm";
      group = "kanidm";
    };
  };

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
    package = pkgs.kanidmWithSecretProvisioning_1_7;

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
      };

      groups.nextcloud-grp.members = [ "wo2w" ];

      systems.oauth2 = {
        nextcloud = {
          displayName = "Nextcloud";
          originUrl = "https://nextcloud.wo2wz.fyi/index.php/apps/user_oidc/code";
          originLanding = "https://nextcloud.wo2wz.fyi/index.php";

          basicSecretFile = config.sops.secrets."kanidm/oauth2/nextcloud".path;
          scopeMaps.nextcloud-grp = [ "openid" "profile" ];
        };
      };
    };

    enableClient = true;
    clientSettings.uri = "https://kanidm.wo2wz.fyi";
  };
}
