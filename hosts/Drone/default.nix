{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    
    ../../modules/common

    ../../modules/nixos/programs/bash.nix
    ../../modules/nixos/programs/git.nix

    ../../modules/nixos/services/homeserver
    ../../modules/nixos/services/tailscale
    ../../modules/nixos/services/restic.nix
    ../../modules/nixos/services/sops.nix
    ../../modules/nixos/services/syncthing
    ../../modules/nixos/services/syncthing/server.nix

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
      options = [ "nofail" ];
    };
    
    "/mnt/external/backup" = {
      device = "zpool-mirror/backup";
      fsType = "zfs";
      options = [ "nofail" ];
    };

    "/mnt/external/storage" = {
      device = "zpool-mirror/storage";
      fsType = "zfs";
      options = [ "nofail" ];
    };

    # bind mounts for file storage dirs on nextcloud from external storage
    "/var/lib/nextcloud/data/534abfe6ec19b02ab61e1196758f7a971e75f07077a431ea15157d8e10910fc5/files" = {
      depends = [ "/mnt/external/storage" ];
      device = "/mnt/external/storage/nextcloud/data/534abfe6ec19b02ab61e1196758f7a971e75f07077a431ea15157d8e10910fc5/files";
      fsType = "none";
      options = [ "bind" "nofail" ];
    };
    "/var/lib/nextcloud/data/534abfe6ec19b02ab61e1196758f7a971e75f07077a431ea15157d8e10910fc5/files_versions" = {
      depends = [ "/mnt/external/storage" ];
      device = "/mnt/external/storage/nextcloud/data/534abfe6ec19b02ab61e1196758f7a971e75f07077a431ea15157d8e10910fc5/files_versions";
      fsType = "none";
      options = [ "bind" "nofail" ];
    };
    "/var/lib/nextcloud/data/534abfe6ec19b02ab61e1196758f7a971e75f07077a431ea15157d8e10910fc5/files_trashbin" = {
      depends = [ "/mnt/external/storage" ];
      device = "/mnt/external/storage/nextcloud/data/534abfe6ec19b02ab61e1196758f7a971e75f07077a431ea15157d8e10910fc5/files_versions";
      fsType = "none";
      options = [ "bind" "nofail" ];
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

