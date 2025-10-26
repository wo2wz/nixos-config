{ config, modulesPath, lib, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")

    ../../modules/common

    ../../modules/nixos/programs/bash.nix
    ../../modules/nixos/programs/git.nix
    
    ../../modules/nixos/services/openssh.nix

    ../../modules/nixos/system/headless.nix
    ../../modules/nixos/system/minimal.nix
  ];

  proxmoxLXC = {
    manageNetwork = false;
    privileged = true;
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;

  services.fstrim.enable = false;

  services.resolved.extraConfig = ''
    Cache=true
    CacheFromLocalhost=true
  '';

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}