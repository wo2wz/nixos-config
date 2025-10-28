{ config, ... }:

{
  imports = [
    ./tailscale
    ./mumble.nix
  ];
}