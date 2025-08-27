{ config, ... }:

{
  services = {
    caddy = {
      enable = true;
      virtualHosts = {
        "drone.taild5f7e6.ts.net".extraConfig = ''
          encode

          # most of this doesnt matter but why not
          header {
              Strict-Transport-Security "max-age=31536000;"
              X-Frame-Options "SAMEORIGIN"
              X-Content-Type-Options "nosniff"
              -Server
              -X-Powered-By
          }

          # block connections to admin login
          respond /admin/* 403
          
          reverse_proxy localhost:8000
        '';

        "wo2wz.fyi".extraConfig = ''
          encode

          header {
              X-Robots-Tag "noindex, nofollow"
              -Server
          }

          respond "not much to see here"
        '';

        "nextcloud.wo2wz.fyi".extraConfig = ''
          encode

          tls ${config.sops.secrets."caddy/wo2wz.fyi.crt".path} ${config.sops.secrets."caddy/wo2wz.fyi.key".path}

          header {
              X-Robots-Tag "noindex, nofollow"
              -Server
          }

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

        "zipline.wo2wz.fyi".extraConfig = ''
          encode

          # most headers are already configured via cloudflare
          header {
              # nobody is gonna find this site through a search engine anyway
              X-Robots-Tag "noindex, nofollow"
              -Server
          }

          # use cloudflare origin certs for https
          tls ${config.sops.secrets."caddy/wo2wz.fyi.crt".path} ${config.sops.secrets."caddy/wo2wz.fyi.key".path}

          reverse_proxy localhost:8001
        '';
      };
    };
    tailscale.permitCertUid = "caddy"; # allow caddy to manage tailscale ssl certs
  };
}