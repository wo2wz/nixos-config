{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common

    ../../modules/nixos/programs/desktop/niri
    ../../modules/nixos/programs/desktop/niri/niri/window-rules/dual-monitor.nix
    ../../modules/nixos/programs/desktop/niri/niri/workspaces/dual-monitor.nix
    ../../modules/nixos/programs/gaming.nix

    ../../modules/nixos/services/syncthing
    ../../modules/nixos/services/syncthing/main.nix
    ../../modules/nixos/services/tailscale

    ../../modules/nixos/system/colors.nix
    ../../modules/nixos/system/console-colors.nix
    ../../modules/nixos/system/desktop.nix
    ../../modules/nixos/system/fonts.nix
    ../../modules/nixos/system/home-manager.nix
    ../../modules/nixos/system/scx.nix
    ../../modules/nixos/system/swap.nix
    ../../modules/nixos/system/yubikey.nix
    ../../modules/nixos/system/zswap.nix
  ];

  fileSystems = {
    "/mnt/internal-nvme" = {
      device = "/dev/disk/by-id/nvme-XF-1TB_2280_9I50708000130_1";
      fsType = "btrfs";
      options = [ "compress=zstd" ];
    };

    "/mnt/internal-nvme/steam" = {
      device = "/dev/disk/by-id/nvme-XF-1TB_2280_9I50708000130_1";
      fsType = "btrfs";
      options = [
        "subvol=steam"
        "compress=zstd"
        "noatime"
      ];
    };
  };

  environment.etc."Yubico/u2f_keys".text = "wo2w:5XpYBFyl+I7J2oecG9eUEhkEmYz9xc7Ne1ymjDBM6bwHbrlStj7u4f0aGn9AJUdCIDVp1VHSBGKj8YrLXXAZeg==,zOM9siNUxu7YTR1OFe2er263M2hLyYq1Ct1/7i/p4rimXzsH/fP5iVC4Etif1yxG/xrivKKyICeRvKr2BTv0DQ==,es256,+presence";

  home-manager.users.wo2w = {
    imports = [
      ../../modules/home
    ];

    programs.btop = {
      package = pkgs.btop-rocm;
      settings = {
        shown_boxes = "cpu mem net proc gpu0";
        custom_cpu_name = "Core i5-12400F";
        custom_gpu_name0 = "RX 6700 XT";
      };
    };

    home.stateVersion = "25.05";
  };

  system.stateVersion = "25.05";
}