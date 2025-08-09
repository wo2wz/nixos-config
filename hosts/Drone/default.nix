{ hostName, config, lib, ... }:

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

  services = {
    scx.scheduler = lib.mkForce "scx_rusty";
    
    cloudflared = {
      enable = true;
      tunnels."8af2892d-d534-4e32-b867-5b79308a99d5" = {
	credentialsFile = "/etc/cloudflared/8af2892d-d534-4e32-b867-5b79308a99d5.json";
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

	"zipline.wo2wz.fyi".extraConfig = ''
	  encode

	  # most are configured by cloudflare already
          header {
#	      Strict-Transport-Security "max-age=31536000;"
#	      X-Frame-Options "DENY"
#	      X-Content-Type-Options "nosniff"
#	      # nobody is gonna find this site through a search engine anyway
	      X-Robots-Tag "noindex, nofollow"
	      -Server
#	      -X-Powered-By
	  }

	  # use cloudflare origin certs for https
	  tls /var/secrets/caddy/wo2wz.fyi.crt /var/secrets/caddy/wo2wz.fyi.key

	  reverse_proxy localhost:3000
	'';

	"wo2wz.fyi".extraConfig = ''
	  encode

	  header {
	      X-Robots-Tag "noindex, nofollow"
	      -Server
	  }

	  respond "not much to see here"
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
      environmentFile = "/var/secrets/vaultwarden/secrets.env";
    };

    zipline = {
      enable = true;
      settings = {
	      FEATURES_VERSION_CHECKING = "false";
      	FEATURES_THUMBNAILS_NUM_THREADS = 2;
      };
      environmentFiles = [ "/var/secrets/zipline/secrets.env" ];
    };
  };

  system.stateVersion = "25.05";
}

