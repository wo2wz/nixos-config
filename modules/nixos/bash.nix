{ config, ... }:

{
  programs.bash.shellAliases = {
    switch = "sudo nixos-rebuild switch";
    boot = "sudo nixos-rebuild boot";
  };
}