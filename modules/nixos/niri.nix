{ config, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    fuzzel
    mako
    waybar
    xwayland-satellite
  ];
}