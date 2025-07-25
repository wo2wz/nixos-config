{ inputs, config, ... }:

{
  imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

  programs.plasma = {
    enable = true;
    workspace.cursor = {
      theme = "Bibata-Modern-Classic";
      size = 24;
    };
  };
}