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
    fonts = {
      sizes = {
        applications = 12;
        desktop = 10;
        popups = 10;
        terminal = 12;
      };

      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  home-manager.users.wo2w.stylix = {
    enable = true;
    targets = {
      btop.enable = false;
      spicetify.enable = false;
      vesktop.enable = false;
      vscode.enable = false;
      fontconfig.enable = false;
      font-packages.enable = false;
      librewolf.profileNames = [ "wo2w" ];
    };
  };
}