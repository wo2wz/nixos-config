{ config, ... }:

{
  imports = [
    ./authentik.nix
    ./caddy.nix
    ./cloudflared.nix
    ./nextcloud.nix
    ./restic.nix
    ./sops.nix
    ./uptime-kuma.nix
    ./vaultwarden.nix
    ./zipline.nix
  ];
}
