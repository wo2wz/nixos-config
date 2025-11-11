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
      package = pkgs.nextcloud32;
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

        default_phone_region = "US";
        maintenance_window_start = 2;
      };

      poolSettings = {
        pm = "dynamic";
        "pm.max_children" = "52";
        "pm.start_servers" = "16";
        "pm.min_spare_servers" = "8";
        "pm.max_spare_servers" = "16";
      };

      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps)
        calendar
        deck
        richdocuments
        tasks
        twofactor_webauthn
        user_oidc;

        files_archive = pkgs.fetchNextcloudApp {   
          url = "https://github.com/rotdrop/nextcloud-app-files-archive/releases/download/v1.2.8/files_archive.tar.gz";
          hash = "sha256:8d02ac423a2c7ef3f039290f56c7981da4002765b50be56bcfa594028a11a4c3";
          license = "agpl3Only";
        };
      };

      maxUploadSize = "200G";
    };
  };

  services.caddy.virtualHosts."collabora.wo2wz.fyi".extraConfig =
    assert config.services.caddy.enable;
    ''
      import default-settings
      import cloudflare-tls

      reverse_proxy localhost:${toString config.services.collabora-online.port}
    '';

  services.collabora-online = {
    enable = true;
    port = 8003;
    settings = {
      server_name = "collabora.wo2wz.fyi";
      net = {
        listen = "loopback";
        post_allow.host = [ ''127\.0\.0\.1'' "::1" ];
      };
      ssl = {
        enable = false;
        termination = true;
      };

      allowed_languages = "en_US";
      remote_font_config.url = "https://nextcloud.wo2wz.fyi/index.php/apps/richdocuments/settings/fonts.json";
    };
  };
}
