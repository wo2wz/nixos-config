{ config, ... }:

{
  programs.git = {
    enable = true;
    userName = "wo2wz";
    userEmail = "189177184+wo2wz@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };
}