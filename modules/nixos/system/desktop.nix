{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # mesa graphics library
  hardware.graphics.enable = true;

  # audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # enable native wayland in chromium/electron
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    kdePackages.gwenview
    krita
    vlc
    jellyfin-tui
    gpu-screen-recorder-gtk
  ];

  # needed alongside the GUI app for promptless recording
  programs.gpu-screen-recorder.enable = true;
}
