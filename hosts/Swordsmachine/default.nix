{ inputs, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../common
    ../../common/desktop
    ../../modules/common
    ../../modules/nixos

    inputs.nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
  ];

  # pin the latest nvidia driver that works because they are so awesome in releasing an update that broke opengl for my 1050ti
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "570.144";
    sha256_64bit = "sha256-wLjX7PLiC4N2dnS6uP7k0TI9xVWAJ02Ok0Y16JVfO+Y=";
    sha256_aarch64 = "sha256-6kk2NLeKvG88QH7/YIrDXW4sgl324ddlAyTybvb0BP0=";
    openSha256 = "sha256-PATw6u6JjybD2OodqbKrvKdkkCFQPMNPjrVYnAZhK/E=";
    settingsSha256 = "sha256-VcCa3P/v3tDRzDgaY+hLrQSwswvNhsm93anmOhUymvM=";
    persistencedSha256 = "sha256-hx4w4NkJ0kN7dkKDiSOsdJxj9+NZwRsZEuhqJ5Rq3nM=";
  };

  environment.systemPackages = with pkgs; [
    # necessary to make the camera not look like the sun
    cameractrls
    # for key replacement macros
    xautomation
    wget
  ];

  home-manager.users.wo2w = {
    imports = [
      ../../modules/home
    ];

    home.stateVersion = "25.05";
  };

  system.stateVersion = "24.11";
}