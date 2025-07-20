{ config, ... }:

{
  # enable yubikey u2f for use with pam
  security.pam.services = {
    sudo.u2fAuth = true;
    polkit-1.u2fAuth = if config.services.desktopManager.plasma6.enable then true else false;
  };

  # yubikey config
  home-manager.users.wo2w.home.file.".config/Yubico/u2f_keys".text = "wo2w:aKYaBOjCImRE58XcYJCqxpY0vABEIYWbk2Lvx4UqnN3M/A1uyr3boV4FZLkfxUwmlfBdMDm4caSaX1/SrNoNgw==,zruscj30G6zEt8xmlvTXBBEKIzg+fPCSq/FvhZO3X0HyP2uBLsWSXqCyRKXM8H9F/GJwJWBpyoHj/dhkxj7eZg==,es256,+presence";
}