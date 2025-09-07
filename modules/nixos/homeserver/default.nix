{ config, ... }:

{
  imports = [
    ./authentik.nix
    ./caddy.nix
    ./cloudflared.nix
    ./nextcloud.nix
    ./sops.nix
    ./vaultwarden.nix
    ./zipline.nix
  ];
}
