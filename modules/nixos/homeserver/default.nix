{ config, ... }:

{
  imports = [
    ./authentik.nix
    ./caddy.nix
    ./cloudflared.nix
    ./nextcloud.nix
    ./sops.nix
    ./uptime-kuma.nix
    ./vaultwarden.nix
    ./zipline.nix
  ];
}
