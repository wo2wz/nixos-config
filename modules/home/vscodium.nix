{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.wo2w = {
      extensions = with pkgs.vscode-extensions; [
        # theme
        enkia.tokyo-night
        # language extensions
        jnoortheen.nix-ide
        # discord rpc
        leonardssh.vscord
      ];

      userSettings = {
        "workbench.colorTheme" = "Tokyo Night";

        # disable trust prompts
        "security.workspace.trust.enabled" = false;
      };
    };
  };
}