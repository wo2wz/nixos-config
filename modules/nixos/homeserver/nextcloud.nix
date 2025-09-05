{ config, pkgs, ... }:

{  
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
        inherit (config.services.nextcloud.package.packages.apps) calendar deck onlyoffice tasks twofactor_webauthn;
      };
    };    

    # onlyoffice document server for rich document editing
    onlyoffice = {
      enable = true;
      hostname = "localhost";
      port = 8003;
      jwtSecretFile = config.sops.secrets."onlyoffice/jwt".path;
    };
  };
}
