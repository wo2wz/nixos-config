{ config, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 8743 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "wo2w" ];
    };
  };
}