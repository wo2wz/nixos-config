{ config, ... }:

{
  imports = [
    ./authentik.nix
    ./caddy.nix
    ./cloudflared.nix
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
