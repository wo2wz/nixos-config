{ config, pkgs, ... }:

{
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    extraConfig = "
      IdentityFile /home/wo2w/.ssh/ssh-key
      User wo2w
      Host gameserver
        Hostname 192.168.2.221
        Port 22
      Host Swordsmachine
        Hostname 192.168.2.84
        Port 8743
      Host Earthmover
        Hostname 192.168.2.87
        Port 8743
    ";
  };

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

  environment = {
    systemPackages = if config.services.desktopManager.plasma6.enable then with pkgs; [ kdePackages.ksshaskpass ] else [];
    variables = {
      SSH_ASKPASS_REQUIRE = "prefer";
    };
  };
}