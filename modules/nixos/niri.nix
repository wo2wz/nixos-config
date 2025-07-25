{ inputs, config, ... }:

{
  imports = [ inputs.niri.nixosModules.niri ];

  programs.niri = {
    enable = true;
    settings = {
      binds = {
        "Mod+Space".action.spawn = [ "rofi" "-show" "drun" ];
        "Print".action.spawn = "spectacle";
        "Mod+Shift+S".action.spawn = [ "spectacle" "-r" ];
      };

      window-rules = {
        bitwarden = {
          matches."^Bitwarden".title = true;
          block-out-from = "screencast";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    rofi-wayland
    mako
    waybar
    xwayland-satellite
  ];
}