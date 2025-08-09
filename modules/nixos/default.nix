{ config, ... }:

{
  imports = [
    ./bash.nix
    ./gaming.nix
    ./kde.nix
    # ./niri.nix
    ./tailscale.nix
  ];
}