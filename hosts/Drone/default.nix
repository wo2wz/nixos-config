{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    
    ../../modules/common

    ../../modules/nixos/programs/bash.nix
    ../../modules/nixos/programs/git.nix

    ../../modules/nixos/services/homeserver
    ../../modules/nixos/services/tailscale

    ../../modules/nixos/system/minimal.nix
  ];
  
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 8192;
  }];

  # config for ZFS external storage
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "58bae81c";
  fileSystems = {
    "/mnt/external" = {
      device = "zpool-mirror";
      fsType = "zfs";
    };
    
    "/mnt/external/backup" = {
      device = "zpool-mirror/backup";
      fsType = "zfs";
    };

    "/mnt/external/storage" = {
      device = "zpool-mirror/storage";
      fsType = "zfs";
    };

    # bind mounts for file storage dirs from external storage
    "/var/lib/nextcloud/data/2fc6e1af776402040d95e1d5adc3babe4928587e84170c882815c808b472b3fa" = {
      depends = [ "/mnt/external/storage" ];
      device = "/mnt/external/storage/nextcloud/data/2fc6e1af776402040d95e1d5adc3babe4928587e84170c882815c808b472b3fa";
      fsType = "none";
      options = [ "bind" ];
    };
  };

  services.zfs.autoScrub.enable = true;

  networking.firewall = lib.mkForce {
    allowedTCPPorts = [];
    allowedTCPPortRanges = [];
    allowedUDPPorts = [];
    allowedUDPPortRanges = [];
  };

  system.stateVersion = "25.05";
}

