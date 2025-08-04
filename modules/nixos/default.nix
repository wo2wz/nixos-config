{ config, ... }:

{
  imports = [
    ./bash.nix
    ./gaming.nix
    ./kde.nix
    # ./niri.nix
    ./ssh.nix
    ./tailscale.nix
  ];
}