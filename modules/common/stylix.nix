{ inputs, config, pkgs, ... }:

{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    targets = {
      fontconfig.enable = false;
      font-packages.enable = false;
    };
    fonts.sizes = {
      applications = 12;
      desktop = 10;
      popups = 10;
      terminal = 12;
    };
  };

  home-manager.users.wo2w.stylix = {
    enable = true;
    targets = {
      spicetify.enable = false;
      vesktop.enable = false;
      vscode.enable = false;
      fontconfig.enable = false;
      font-packages.enable = false;
      librewolf.profileNames = [ "wo2w" ];
    };
  };
}