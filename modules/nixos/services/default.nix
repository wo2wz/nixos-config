{ config, ... }:

{
  imports = [
    ./mumble.nix
    ./openssh.nix
    ./tailscale.nix
  ];
}