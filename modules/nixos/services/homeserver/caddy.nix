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
        plugins = [
          "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
          "github.com/tailscale/caddy-tailscale@v0.0.0-20250915161136-32b202f0a953"
        ];
        hash = "sha256-icldgfR6CidNdsM/AcpaV484hrljGxj5KiAqTOjlKgg=";
      };
      environmentFile = config.sops.secrets."caddy/secrets.env".path;

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
      globalConfig = ''
        grace_period 30s
        servers {
            client_ip_headers CF-Connecting-Ip X-Forwarded-For
            trusted_proxies cloudflare {
                interval 7d
                timeout 15s
            }
            trusted_proxies_strict
        }

        tailscale {
            auth_key {env.CADDY_TAILSCALE_AUTH_KEY}
            state_dir ${config.services.caddy.dataDir}/caddy-tailscale
        }
      '';

      virtualHosts."wo2wz.fyi".extraConfig = ''
        import default-settings
        import cloudflare-tls

        respond "not much to see here"
      '';
    };
  };
}
