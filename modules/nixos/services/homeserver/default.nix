{ config, ... }:

{
  imports = [
    ./grafana
    ./caddy.nix
    ./cloudflared.nix
    ./jellyfin.nix
    ./kanidm.nix
    ./nextcloud.nix
    ./ntfy.nix
    ./restic.nix
    ./sops.nix
    ./uptime-kuma.nix
    ./vaultwarden.nix
    ./zed.nix
  ];
}
