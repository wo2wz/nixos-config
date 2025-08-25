{ config, pkgs, ... }:

{
  users.users.caddy.extraGroups = [ "nextcloud" ];
  services = {
    nginx.enable = false; # disable to use caddy instead
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
}