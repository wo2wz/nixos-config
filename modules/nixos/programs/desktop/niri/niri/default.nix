{ inputs, config, pkgs, ... }:

{
  imports = [
    ./window-rules
    ./binds.nix

    inputs.niri.nixosModules.niri
  ];

  # compositor: niri
  # bar: waybar
  # wallpaper: swaybg
  # application launcher: rofi
  # idle daemon: hypridle
  # screen locker: hyprlock
  # notification daemon: mako
  # screenshot tool: flameshot
  # file manager: yazi

  programs.niri.enable = true;

  environment.systemPackages = [
    pkgs.xwayland-satellite # necessary for xwayland on niri
    pkgs.bibata-cursors
  ];

  xdg.portal.config.niri = {
    default = "gtk";
    "org.freedesktop.impl.portal.ScreenCast" = "gnome";
    "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
  };

  home-manager.users.wo2w.programs.niri.settings = {
    hotkey-overlay.skip-at-startup = true;
    prefer-no-csd = true;

    gestures.hot-corners.enable = false;
    input.touchpad.natural-scroll = false;

    cursor = {
      theme = "Bibata-Modern-Classic";
      size = 24;
    };

    layout.focus-ring = {
      active.color = config.custom.colors.base0D;
      inactive.color = config.custom.colors.base0E;
    };

    screenshot-path = "~/Pictures/Screenshots/%F_%H-%M-%S";

    outputs = {
      "Sharp Corporation 0x148D Unknown".scale = 2.25; # Laptop builtin screen
    };

    # fix screen tearing in games
    debug.wait-for-frame-completion-before-queueing = {};
  };
}