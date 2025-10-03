{ config, pkgs, ... }:

{
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

      virtualHosts = {
        "vaultwarden.taild5f7e6.ts.net".extraConfig = ''
          import default-settings

          bind tailscale/vaultwarden

          # block connections to admin login
          respond /admin/* 403

          reverse_proxy localhost:8000
        '';

        "wo2wz.fyi".extraConfig = ''
          import default-settings
          import cloudflare-tls

          respond "not much to see here"
        '';

        "authentik.wo2wz.fyi".extraConfig = ''
          import default-settings
          import cloudflare-tls

          reverse_proxy localhost:9000
        '';

        "nextcloud.wo2wz.fyi".extraConfig = ''
          import default-settings

          root ${config.services.nginx.virtualHosts."localhost:8002".root}
          file_server

          php_fastcgi unix/${config.services.phpfpm.pools.nextcloud.socket}

          redir /.well-known/carddav /remote.php/dav 301
          redir /.well-known/caldav /remote.php/dav 301
          redir /.well-known/webfinger /index.php/webfinger 301
          redir /.well-known/nodeinfo /index.php/nodeinfo 301
          redir /.well-known/* /index.php{uri} 301
          redir /remote/* /remote.php{uri} 301

          @forbidden {
            path /build/* /tests/* /config/* /lib/* /3rdparty/* /templates/* /data/*
            path /.* /autotest* /occ* /issue* /indie* /db_* /console*
            not path /.well-known/*
          }

          respond @forbidden 403

          # make .mjs javascript work for the functionality of some buttons/apps
          @mjs path *.mjs
          header @mjs Content-Type application/javascript
        '';

        "onlyoffice.wo2wz.fyi".extraConfig = ''
          import default-settings
          import cloudflare-tls

          @blockinternal {
            path /internal/*
            path /info/*
            not remote_ip 127.0.0.1
          }
          respond @blockinternal 403

          reverse_proxy localhost:8003 
        '';

        "uptime-kuma.wo2wz.fyi".extraConfig = ''
          import default-settings
          import cloudflare-tls

          reverse_proxy localhost:8005
        '';

        "zipline.wo2wz.fyi".extraConfig = ''
          import default-settings
          import cloudflare-tls

          reverse_proxy localhost:8001
        '';
      };
    };
    tailscale.permitCertUid = "caddy"; # allow caddy to manage tailscale ssl certs
  };
}
