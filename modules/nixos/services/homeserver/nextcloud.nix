{ config, pkgs, ... }:

{  
  sops.secrets."nextcloud/adminpass" = {};

  services.caddy.virtualHosts."nextcloud.wo2wz.fyi".extraConfig =
    assert config.services.caddy.enable;
    ''
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

  services.nginx.enable = false; # disable to use caddy instead
  users.users.nginx = {
    group = "nginx";
    isSystemUser = true;
  };
  users.groups.nginx = {};

  users.users.caddy.extraGroups = [ "nextcloud" ];
  services.phpfpm.pools.nextcloud.settings = {
    "listen.owner" = "caddy";
    "listen.group" = "caddy";
  };

  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "localhost:8002";
      configureRedis = true;
      config = {
        adminuser = "wo2w";
        adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
        dbtype = "sqlite";
      };
      settings = {
        trusted_domains = [ "nextcloud.wo2wz.fyi" ];
        trusted_proxies = [ "127.0.0.1" "::1" ];
      };

      maxUploadSize = "200G";
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) calendar deck onlyoffice tasks music twofactor_webauthn user_oidc;
      };
    };
  };

  sops.secrets."onlyoffice/jwt" = {
    owner = "onlyoffice";
    group = "onlyoffice";
  };

  services.caddy.virtualHosts."onlyoffice.wo2wz.fyi".extraConfig =
    assert config.services.caddy.enable;
    ''
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

  services.onlyoffice = {
    enable = true;
    hostname = "localhost";
    port = 8003;
    jwtSecretFile = config.sops.secrets."onlyoffice/jwt".path;
  };
}
