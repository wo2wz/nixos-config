{ config, pkgs, ... }:

{
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    extraConfig = "
      Host gameserver
        Hostname 192.168.2.221
        Port 22
        User wo2w
        IdentityFile /home/wo2w/.ssh/ssh-key
    ";
  };

  environment = {
    systemPackages = if config.services.desktopManager.plasma6.enable then with pkgs; [ kdePackages.ksshaskpass ] else [];
    variables = {
      SSH_ASKPASS_REQUIRE = "prefer";
    };
  };
}