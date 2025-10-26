{ config, ... }:

{
  # see modules/common/debloat.nix

  documentation = {
    enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  xdg = {
    autostart.enable = false;
    icons.enable = false;
    mime.enable = false;
    sounds.enable = false;
  };
}