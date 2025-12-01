{ config, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "wo2wz";
        email = "189177184+wo2wz@users.noreply.github.com";
      };

      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };
}