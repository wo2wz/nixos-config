{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.chaotic.nixosModules.nyx-cache
    inputs.chaotic.nixosModules.nyx-overlay
    inputs.chaotic.nixosModules.nyx-registry
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_cachyos;
  };

  services.scx = {
    enable = true;
    # use gaming performance scheduler
    scheduler = "scx_lavd";
  };
}