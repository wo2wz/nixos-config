{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # mesa graphics library
    graphics.enable = true;
  };

  # audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # CUPS
  services.printing.enable = true;

  # enable native wayland in chromium/electron
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    bitwarden
    kdePackages.gwenview
    krita
    vlc
    gpu-screen-recorder-gtk
  ];

  # needed alongside the GUI app for promptless recording
  programs.gpu-screen-recorder.enable = true;
}