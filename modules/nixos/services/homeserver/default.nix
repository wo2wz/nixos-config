{ config, ... }:

{
  imports = [
    ./caddy.nix
    ./cloudflared.nix
    ./kanidm.nix
    ./nextcloud.nix
    ./ntfy.nix
    ./restic.nix
    ./sops.nix
    ./uptime-kuma.nix
    ./vaultwarden.nix
    ./zed.nix
    ./zipline.nix
  ];
}
