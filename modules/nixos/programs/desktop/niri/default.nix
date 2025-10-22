{ config, ... }:

{
  imports = [
    ./niri
    ./waybar
    ./flameshot.nix
    ./fuzzel.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./mako.nix
    ./swaybg.nix
    ./tuigreet.nix
    ./yazi.nix
  ];
}