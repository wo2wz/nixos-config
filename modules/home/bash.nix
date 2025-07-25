{ config, ... }:

{
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        switch = "sudo nixos-rebuild switch";
        boot = "sudo nixos-rebuild boot";
      };
    };
    
    kitty.shellIntegration.enableBashIntegration = if config.programs.kitty.enable then true else false;
  };
}