{ config, ... }:

{
  imports = [
    ./mumble.nix
    ./tailscale.nix
  ];
}