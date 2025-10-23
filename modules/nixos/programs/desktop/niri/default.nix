{ config, ... }:

{
  imports = [
    ./niri
    ./waybar
    ./fuzzel.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./mako.nix
    ./swaybg.nix
    ./tuigreet.nix
    ./yazi.nix
  ];
}