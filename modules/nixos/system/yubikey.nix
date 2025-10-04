{ config, ... }:

{
  # enable yubikey u2f for use with pam
  security.pam.services = {
    sudo.u2fAuth = true;
    polkit-1.u2fAuth = if config.services.desktopManager.plasma6.enable then true else false;
  };
}