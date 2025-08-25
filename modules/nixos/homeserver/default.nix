{ config, ... }:

{
  imports = [
    ./caddy.nix
    ./cloudflared.nix
    ./nextcloud.nix
    ./sops.nix
    ./vaultwarden.nix
    ./zipline.nix
  ];
}