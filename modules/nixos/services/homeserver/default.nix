{ config, ... }:

{
  imports = [
    ./grafana
    ./restic
    ./caddy.nix
    ./cloudflared.nix
    ./jellyfin.nix
    ./kanidm.nix
    ./nextcloud.nix
    ./ntfy.nix
    ./sops.nix
    ./uptime-kuma.nix
    ./vaultwarden.nix
    ./zed.nix
  ];
}
