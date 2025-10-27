{ config, pkgs, ... }:

{
  programs.ssh.extraConfig = "
    IdentityFile /home/wo2w/.ssh/yubikey
    User wo2w
    Port 8743
    Host Gutterman
      Hostname 192.168.2.112
    Host Swordsmachine
      Hostname 192.168.2.74
    Host Earthmover
      Hostname 192.168.2.175
  ";
}