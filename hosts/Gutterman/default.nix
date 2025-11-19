{ inputs, config, modulesPath, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")

    ../../modules/common

    ../../modules/nixos/programs/bash.nix
    ../../modules/nixos/programs/git.nix

    ../../modules/nixos/services/tailscale
    ../../modules/nixos/services/gameserver/minecraft-server.nix

    ../../modules/nixos/system/headless.nix
    ../../modules/nixos/system/minimal.nix
  ];

  proxmoxLXC.manageHostName = true;

  # enabled by default in the proxmox-lxc module in nixpkgs
  services.openssh.enable = false;

  boot.loader.systemd-boot.enable = lib.mkForce false;

  services.fstrim.enable = false;

  services.resolved.extraConfig = ''
    Cache=true
    CacheFromLocalhost=true
  '';

  environment.systemPackages = [
    pkgs.btop
    pkgs.steamcmd
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
