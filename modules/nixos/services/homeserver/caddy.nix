{ config, pkgs, ... }:

{
  sops.secrets = {
    "caddy/secrets.env" = {};

    "caddy/wo2wz.fyi.crt" = {
      owner = "caddy";
      group = "caddy";
      reloadUnits = [ "caddy.service" ];
    };
    "caddy/wo2wz.fyi.key" = {
      owner = "caddy";
      group = "caddy";
      reloadUnits = [ "caddy.service" ];
    };
  };

  services = {
    caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/tailscale/caddy-tailscale@v0.0.0-20260106222316-bb080c4414ac" ];
        hash = "sha256-1BAY6oZ1qJCKlh0Y2KKqw87A45EUPVtwS2Su+LfXtCc=";
      };
      environmentFile = config.sops.secrets."caddy/secrets.env".path;

      # caddy-tailscale breaks reloading
      enableReload = false;

      extraConfig = ''
        (cloudflare-tls) {
            tls ${config.sops.secrets."caddy/wo2wz.fyi.crt".path} ${config.sops.secrets."caddy/wo2wz.fyi.key".path}
        }

        (default-settings) {
            encode

            header {
                Strict-Transport-Security "max-age=15552000;"
                X-Frame-Options "SAMEORIGIN"
                X-Content-Type-Options "nosniff"
                X-Robots-Tag "noindex, nofollow"
                -Server
                -X-Powered-By
            }
        }
      '';
      # have to specify node tags here because if there are two tailscale blocks it just dont work
      globalConfig = ''
        grace_period 30s

        metrics {
            per_host
        }

        servers {
            client_ip_headers CF-Connecting-Ip X-Forwarded-For
            trusted_proxies static 127.0.0.1 ::1
        }

        tailscale {
            auth_key {env.CADDY_TAILSCALE_AUTH_KEY}
            state_dir ${config.services.caddy.dataDir}/caddy-tailscale

            ephemeral true

            tags tag:drone

            grafana {
                tags tag:drone tag:grafana
            }
            jellyfin {
                tags tag:drone tag:jellyfin
            }
            ntfy {
                tags tag:drone tag:ntfy
            }
            prometheus {
                tags tag:drone tag:prometheus
            }
            restic {
                tags tag:drone tag:restic
            }
            technitium {
                tags tag:drone tag:technitium
            }
            vaultwarden {
                tags tag:drone tag:vaultwarden
            }
        }
      '';

      virtualHosts."wo2wz.fyi".extraConfig = ''
        import default-settings
        import cloudflare-tls

        respond "{client_ip}"
      '';
    };
  };
}
