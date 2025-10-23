{ config, ... }:

{
  # enable yubikey u2f for use with pam
  security.pam = {
    services = {
      sudo.u2fAuth = true;
      polkit-1.u2fAuth = true;
    };

    u2f.settings = {
      authfile = "/etc/Yubico/u2f_keys";
      cue = true;
    };
  };
}