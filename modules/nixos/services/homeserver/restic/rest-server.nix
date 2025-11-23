{ config, ... }:

{
  sops.secrets."restic/rest-server/.htpasswd" = {
    owner = "restic";
    group = "restic";
  };

  services.caddy.virtualHosts."restic.taild5f7e6.ts.net".extraConfig =
  assert config.services.caddy.enable;
  ''
    import default-settings

    bind tailscale/restic

    reverse_proxy localhost:8001
  '';

  services.restic.server = {
    enable = true;
    dataDir = "/mnt/external/backup/restic";
    listenAddress = "127.0.0.1:8001";
    htpasswd-file = config.sops.secrets."restic/rest-server/.htpasswd".path;

    privateRepos = true;
    appendOnly = true;
  };
}