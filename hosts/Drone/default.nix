{ hostName, inputs, config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    
    ../../common/ssh/server.nix
    ../../common/boot.nix
    ../../common/locales.nix
    ../../common/nix.nix
    ../../common/users.nix

    ../../modules/nixos/bash.nix
    ../../modules/nixos/tailscale.nix

    inputs.sops-nix.nixosModules.sops
  ];
  
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 8192;
  }];

  networking = {
    hostName = "${hostName}";
    firewall = lib.mkForce {
      allowedTCPPorts = [];
      allowedTCPPortRanges = [];
      allowedUDPPorts = [];
      allowedUDPPortRanges = [];
    };
  };

  environment.defaultPackages = lib.mkForce [];
  
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "wo2wz";
        email = "189177184+wo2wz@users.noreply.github.com";
      };
      safe.directory = "/etc/nixos";
    };
  };

  sops = {
    defaultSopsFile = "/etc/nixos/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;

    age.keyFile = "/root/.config/sops/age/keys.txt";

    secrets = {
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

      "cloudflared/8af2892d-d534-4e32-b867-5b79308a99d5.json" = {};

      "nextcloud/adminpass" = {};

      "vaultwarden/secrets.env".restartUnits = [ "vaultwarden.service" ];

      "zipline/secrets.env".restartUnits = [ "zipline.service" ];
    };
  };

  users.users.caddy.extraGroups = [ "nextcloud" ];

  services = {
    scx.scheduler = lib.mkForce "scx_rusty";

    # for cloudflare browser ssh
    openssh.settings.Macs = [
        "hmac-sha2-512"
        "hmac-sha2-256"
    ];
    
    cloudflared = {
      enable = true;
      tunnels."8af2892d-d534-4e32-b867-5b79308a99d5" = {
	      credentialsFile = config.sops.secrets."cloudflared/8af2892d-d534-4e32-b867-5b79308a99d5.json".path;
	      default = "http_status:418";
      };
    };

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

          reverse_proxy localhost:3000
        '';

        "nextcloud.wo2wz.fyi".extraConfig = ''
          encode

          tls ${config.sops.secrets."caddy/wo2wz.fyi.crt".path} ${config.sops.secrets."caddy/wo2wz.fyi.key".path}

          header {
              X-Robots-Tag "noindex, nofollow"
              -Server
          }

          root ${config.services.nginx.virtualHosts."localhost:8001".root}
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
      };
    };

    tailscale.permitCertUid = "caddy"; # allow caddy to manage tailscale ssl certs

    vaultwarden = {
      enable = true;
      backupDir = "/var/backups/vaultwarden";
      config = {
        DOMAIN = "https://drone.taild5f7e6.ts.net";

        SIGNUPS_ALLOWED = false;
      };
      environmentFile = config.sops.secrets."vaultwarden/secrets.env".path;
    };

    zipline = {
      enable = true;
      settings = {
	      FEATURES_VERSION_CHECKING = "false";
      	FEATURES_THUMBNAILS_NUM_THREADS = 2;
      };
      environmentFiles = [ config.sops.secrets."zipline/secrets.env".path ];
    };

    nginx.enable = false;
    phpfpm.pools.nextcloud.settings = {
      "listen.owner" = "caddy";
      "listen.group" = "caddy";
    };
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "localhost:8001";
      config = {
        adminuser = "wo2w";
        adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
        dbtype = "sqlite";
      };
      settings = {
        trusted_domains = [ "nextcloud.wo2wz.fyi" ];
        trusted_proxies = [ "127.0.0.1" ];
      };

      maxUploadSize = "200G";
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) calendar tasks deck twofactor_webauthn;
      };
    };
  };

  system.stateVersion = "25.05";
}

