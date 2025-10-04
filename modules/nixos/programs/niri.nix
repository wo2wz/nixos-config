{ hostName, inputs, config, lib, pkgs, ... }:

{
  # compositor: niri
  # bar: waybar
  # application launcher: rofi
  # idle daemon: hypridle
  # screen locker: hyprlock
  # wallpaper daemon: wpaperd
  # notification daemon: mako
  # screenshot tool: flameshot


  imports = [ inputs.niri.nixosModules.niri ];
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    wpaperd # wallpaper daemon (higher memory usage than average, could replace)
    xwayland-satellite # necessary for xwayland on niri
    (flameshot.override { enableWlrSupport = true; }) # screenshot program
  ];

  xdg.portal.config = {
    niri = {
      default = "gtk";
      "org.freedesktop.impl.portal.ScreenCast" = "gnome";
      "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
    };
  };

  home-manager.users.wo2w = {
    xdg.configFile."wpaperd/config.toml".text = ''
      [default]
      duration = "2h"
      mode = "stretch"
      path = "/home/wo2w/Pictures/Wallpapers"
      initial-transition = false
    '';

    programs = {
      niri = {
        settings = {
          hotkey-overlay.skip-at-startup = true;
          prefer-no-csd = true;

          environment.DISPLAY = ":0";

          screenshot-path = "~/Pictures/Screenshots/%F_%H-%M-%S";

          outputs = {
            "Sharp Corporation 0x148D Unknown".scale = 2.25; # Laptop builtin screen
          };

          binds = {
            # custom binds
            "Mod+Space".action.spawn = [ "rofi" "-show" "drun" ];
            "Print".action.screenshot-screen = {};
            "Shift+Print".action.screenshot = {};
            "Alt+Print".action.screenshot-window = {};
            "Mod+Print".action.spawn = [ "sh" "-c" "QT_QPA_PLATFORM=xcb" "DISPLAY=:0" "flameshot" "full" ];
            "Mod+T".action.spawn = "kitty";
          
            "Super+Alt+L".action.spawn = "hyprlock";
            "Super+Alt+S".action.spawn = [ "systemctl" "sleep" ];
            "Super+Alt+E".action.quit.skip-confirmation = true;
            "Super+Alt+Shift+S".action.spawn = "poweroff";
            "Super+Alt+Shift+R".action.spawn = "reboot";

            "Super+Alt+F".action.fullscreen-window = {};

            "Mod+O".action.open-overview = {};
            "Mod+V".action.toggle-window-floating = {};
            "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};
            

            # default binds

            # Mod-Shift-/, which is usually the same as Mod-?,
            # shows a list of important hotkeys.
            "Mod+Shift+Slash".action.show-hotkey-overlay = {};

            # You can also use a shell. Do this if you need pipes, multiple commands, etc.
            # Note: the entire command goes as a single argument in the end.
            # Mod+T { spawn "bash" "-c" "notify-send hello && exec alacritty"; }

            # Example volume keys mappings for PipeWire & WirePlumber.
            # The allow-when-locked=true property makes them work even when the session is locked.
            "XF86AudioRaiseVolume" = {
              allow-when-locked = true;
              action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" ];
            };
            "XF86AudioLowerVolume" = {
              allow-when-locked = true;
              action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
            };
            "XF86AudioMute" = {
              allow-when-locked = true;
              action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
            };
            "XF86AudioMicMute" = {
              allow-when-locked = true;
              action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
            };

            "Mod+Q".action.close-window = {};

            "Mod+Left".action.focus-column-left = {};
            "Mod+Down".action.focus-window-down = {};
            "Mod+Up".action.focus-window-up = {};
            "Mod+Right".action.focus-column-right = {};
            "Mod+H".action.focus-column-left = {};
            "Mod+J".action.focus-window-down = {};
            "Mod+K".action.focus-window-up = {};
            "Mod+L".action.focus-column-right = {};

            "Mod+Ctrl+Left".action.move-column-left = {};
            "Mod+Ctrl+Down".action.move-window-down = {};
            "Mod+Ctrl+Up".action.move-window-up = {};
            "Mod+Ctrl+Right".action.move-column-right = {};
            "Mod+Ctrl+H".action.move-column-left = {};
            "Mod+Ctrl+J".action.move-window-down = {};
            "Mod+Ctrl+K".action.move-window-up = {};
            "Mod+Ctrl+L".action.move-column-right = {};

            # Alternative commands that move across workspaces when reaching
            # the first or last window in a column.
            # Mod+J     { focus-window-or-workspace-down; }
            # Mod+K     { focus-window-or-workspace-up; }
            # Mod+Ctrl+J     { move-window-down-or-to-workspace-down; }
            # Mod+Ctrl+K     { move-window-up-or-to-workspace-up; }

            "Mod+Home".action.focus-column-first = {};
            "Mod+End".action.focus-column-last = {};
            "Mod+Ctrl+Home".action.move-column-to-first = {};
            "Mod+Ctrl+End".action.move-column-to-last = {};

            "Mod+Shift+Left".action.focus-monitor-left = {};
            "Mod+Shift+Down".action.focus-monitor-down = {};
            "Mod+Shift+Up".action.focus-monitor-up = {};
            "Mod+Shift+Right".action.focus-monitor-right = {};
            "Mod+Shift+H".action.focus-monitor-left = {};
            "Mod+Shift+J".action.focus-monitor-down = {};
            "Mod+Shift+K".action.focus-monitor-up = {};
            "Mod+Shift+L".action.focus-monitor-right = {};

            "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = {};
            "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = {};
            "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = {};
            "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = {};
            "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = {};
            "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = {};
            "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = {};
            "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = {};

            # Alternatively, there are commands to move just a single window:
            # Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
            # ...

            # And you can also move a whole workspace to another monitor:
            # Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
            # ...

            "Mod+Page_Down".action.focus-workspace-down = {};
            "Mod+Page_Up".action.focus-workspace-up = {};
            "Mod+U".action.focus-workspace-down = {};
            "Mod+I".action.focus-workspace-up = {};
            "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
            "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = {};
            "Mod+Ctrl+U".action.move-column-to-workspace-down = {};
            "Mod+Ctrl+I".action.move-column-to-workspace-up = {};

            # Alternatively, there are commands to move just a single window:
            # Mod+Ctrl+Page_Down { move-window-to-workspace-down; }
            # ...

            "Mod+Shift+Page_Down".action.move-workspace-down = {};
            "Mod+Shift+Page_Up".action.move-workspace-up = {};
            "Mod+Shift+U".action.move-workspace-down = {};
            "Mod+Shift+I".action.move-workspace-up = {};

            # You can bind mouse wheel scroll ticks using the following syntax.
            # These binds will change direction based on the natural-scroll setting.
            #
            # To avoid scrolling through workspaces really fast, you can use
            # the cooldown-ms property. The bind will be rate-limited to this value.
            # You can set a cooldown on any bind, but it's most useful for the wheel.
            "Mod+WheelScrollDown" = {
              cooldown-ms = 150;
              action.focus-workspace-down = {};
            };
            "Mod+WheelScrollUp" = {
              cooldown-ms = 150;
              action.focus-workspace-up = {};
            };
            "Mod+Ctrl+WheelScrollDown" = {
              cooldown-ms = 150;
              action.move-column-to-workspace-down = {};
            };
            "Mod+Ctrl+WheelScrollUp" = {
              cooldown-ms = 150;
              action.move-column-to-workspace-up = {};
            };

            "Mod+WheelScrollRight".action.focus-column-right = {};
            "Mod+WheelScrollLeft".action.focus-column-left = {};
            "Mod+Ctrl+WheelScrollRight".action.move-column-right = {};
            "Mod+Ctrl+WheelScrollLeft".action.move-column-left = {};

            # Usually scrolling up and down with Shift in applications results in
            # horizontal scrolling; these binds replicate that.
            "Mod+Shift+WheelScrollDown".action.focus-column-right = {};
            "Mod+Shift+WheelScrollUp".action.focus-column-left = {};
            "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = {};
            "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = {};

            # Similarly, you can bind touchpad scroll "ticks".
            # Touchpad scrolling is continuous, so for these binds it is split into
            # discrete intervals.
            # These binds are also affected by touchpad's natural-scroll, so these
            # example binds are "inverted", since we have natural-scroll enabled for
            # touchpads by default.
            # Mod+TouchpadScrollDown { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+"; }
            # Mod+TouchpadScrollUp   { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-"; }

            # You can refer to workspaces by index. However, keep in mind that
            # niri is a dynamic workspace system, so these commands are kind of
            # "best effort". Trying to refer to a workspace index bigger than
            # the current workspace count will instead refer to the bottommost
            # (empty) workspace.
            #
            # For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
            # will all refer to the 3rd workspace.
            "Mod+1".action.focus-workspace = 1;
            "Mod+2".action.focus-workspace = 2;
            "Mod+3".action.focus-workspace = 3;
            "Mod+4".action.focus-workspace = 4;
            "Mod+5".action.focus-workspace = 5;
            "Mod+6".action.focus-workspace = 6;
            "Mod+7".action.focus-workspace = 7;
            "Mod+8".action.focus-workspace = 8;
            "Mod+9".action.focus-workspace = 9;
            "Mod+Ctrl+1".action.move-column-to-workspace = 1;
            "Mod+Ctrl+2".action.move-column-to-workspace = 2;
            "Mod+Ctrl+3".action.move-column-to-workspace = 3;
            "Mod+Ctrl+4".action.move-column-to-workspace = 4;
            "Mod+Ctrl+5".action.move-column-to-workspace = 5;
            "Mod+Ctrl+6".action.move-column-to-workspace = 6;
            "Mod+Ctrl+7".action.move-column-to-workspace = 7;
            "Mod+Ctrl+8".action.move-column-to-workspace = 8;
            "Mod+Ctrl+9".action.move-column-to-workspace = 9;

            # Alternatively, there are commands to move just a single window:
            # Mod+Ctrl+1 { move-window-to-workspace 1; }

            # Switches focus between the current and the previous workspace.
            # Mod+Tab { focus-workspace-previous; }

            "Mod+Comma".action.consume-window-into-column = {};
            "Mod+Period".action.expel-window-from-column = {};

            # There are also commands that consume or expel a single window to the side.
            "Mod+BracketLeft".action.consume-or-expel-window-left = {};
            "Mod+BracketRight".action.consume-or-expel-window-right = {};

            "Mod+R".action.switch-preset-column-width = {};
            "Mod+Shift+R".action.reset-window-height = {};
            "Mod+F".action.maximize-column = {};
            "Mod+Shift+F".action.fullscreen-window = {};
            "Mod+C".action.center-column = {};

            # Finer width adjustments.
            # This command can also:
            # * set width in pixels: "1000"
            # * adjust width in pixels: "-5" or "+5"
            # * set width as a percentage of screen width: "25%"
            # * adjust width as a percentage of screen width: "-10%" or "+10%"
            # Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
            # set-column-width "100" will make the column occupy 200 physical screen pixels.
            "Mod+Minus".action.set-column-width = "-10%";
            "Mod+Equal".action.set-column-width = "+10%";

            # Finer height adjustments when in column with other windows.
            "Mod+Shift+Minus".action.set-window-height = "-10%";
            "Mod+Shift+Equal".action.set-window-height = "+10%";

            "Ctrl+Print".action.screenshot-screen = {};
            "Alt+Print".action.screenshot-window = {};

            # Powers off the monitors. To turn them back on, do any input like
            # moving the mouse or pressing any other key.
            "Mod+Shift+P".action.power-off-monitors = {};
          };

          spawn-at-startup = [
            { command = [ "xwayland-satellite" ]; }
            { command = [ "wpaperd" "-d" ]; }
          ];

          workspaces = if "${hostName}" == "Earthmover" then {
            "01-DP-1-misc" = {
              name = "Miscellaneous";
              open-on-output = "DP-1";
            };
            "02-DP-1-game" = {
              name = "Gaming";
              open-on-output = "DP-1";
            };
            "03-DP-2-fullscreen" = {
              name = "Fullscreen";
              open-on-output = "DP-2";
            };
            "04-DP-2-misc" = {
              name = "Miscellaneous 2";
              open-on-output = "DP-2";
            };
          }
          else if "${hostName}" == "Swordsmachine" then {
            "01-misc".name = "Miscellaneous";
            "02-fullscreen".name = "Fullscreen";
            "03-game".name = "Gaming";
          }
          else {};

          window-rules = if "${hostName}" == "Earthmover" then [
            {
              matches = [{ title = "^Bitwarden$"; }];
              block-out-from = "screen-capture";
            }
            {
              matches = [{ app-id = "^org.kde.polkit-kde-authentication-agent-1$"; }];
              block-out-from = "screen-capture";
              open-floating = true;
            }
            # put steam notifications in the bottom right
            {
              matches = [
                { app-id = "steam"; }
                { title = "^notificationtoasts_\d+_desktop$"; }
              ];
              default-floating-position = {
                x = 10;
                y = 10;
                relative-to = "bottom-right";
              };
            }
            # Gaming (DP-1)
            {
              matches = [
                { app-id = "steam"; }
                { title = "^Steam$"; }
              ];
              open-on-workspace = "Gaming";
              open-maximized = true;
            }
            {
              matches = [{ app-id = "heroic"; }];
              open-on-workspace = "Gaming";
              open-maximized = true;
            }
            {
              matches = [{ app-id = "org.prismlauncher.PrismLauncher"; }];
              open-on-workspace = "Gaming";
            }
            {
              matches = [{ app-id = "vesktop"; }];
              open-on-workspace = "Gaming";
              open-maximized = true;
            }
            # Fullscreen (DP-2)
            {
              matches = [{ app-id = "librewolf"; }];
              open-on-workspace = "Fullscreen";
              open-maximized = true;
            }
            {
              matches = [{ app-id = "spotify"; }];
              open-on-workspace = "Fullscreen";
              open-maximized = true;
            }
            # Miscellaneous 2 (DP-2)
            {
              matches = [{ app-id = "com.dec05eba.gpu_screen_recorder"; }];
              open-on-workspace = "Miscellaneous 2";
            }
          ]
          else if "${hostName}" == "Swordsmachine" then [
            {
              matches = [{ title = "^Bitwarden$"; }];
              block-out-from = "screen-capture";
            }
            {
              matches = [{ app-id = "^org.kde.polkit-kde-authentication-agent-1$"; }];
              block-out-from = "screen-capture";
              open-floating = true;
            }
            # put steam notifications in the bottom right
            {
              matches = [
                { app-id = "steam"; }
                { title = "^notificationtoasts_\d+_desktop$"; }
              ];
              default-floating-position = {
                x = 10;
                y = 10;
                relative-to = "bottom-right";
              };
            }
            # Miscellaneous
            {
              matches = [{ app-id = "com.dec05eba.gpu_screen_recorder"; }];
              open-on-workspace = "Miscellaneous";
              open-floating = false;
            }
            # Gaming
            {
              matches = [
                { app-id = "steam"; }
                { title = "^Steam$"; }
              ];
              open-on-workspace = "Gaming";
              open-maximized = true;
            }
            {
              matches = [{ app-id = "heroic"; }];
              open-on-workspace = "Gaming";
              open-maximized = true;
            }
            {
              matches = [{ app-id = "org.prismlauncher.PrismLauncher"; }];
              open-on-workspace = "Gaming";
            }
            {
              matches = [{ app-id = "vesktop"; }];
              open-on-workspace = "Gaming";
              open-maximized = true;
            }
            # Fullscreen
            {
              matches = [{ app-id = "librewolf"; }];
              open-on-workspace = "Fullscreen";
              open-maximized = true;
            }
            {
              matches = [{ app-id = "spotify"; }];
              open-on-workspace = "Fullscreen";
              open-maximized = true;
            }
            {
              matches = [{ app-id = "org.kde.okular"; }];
              open-on-workspace = "Fullscreen";
              open-maximized = true;
            }
          ]
          else [];
        };
      };

      waybar = {
        enable = true;
        systemd.enable = true;
      };

      rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        plugins = with pkgs; [
          rofi-calc
        ];
      };

      hyprlock = {
        enable = true;
        settings = {
          general.grace = 5;

          background = {
            path = "/home/wo2w/Pictures/uni1.jpg";
            blur_passes = 3;
          };

          label = [
            {
              valign = "top";
              position = "0, -400";
              font_size = 128;
              text = "$TIME";
            }
            {
              position = "0, 180";
              font_size = 64;
              text = "$DESC";
            }
          ];

          input-field = {
            position = "0, -80";
            size = "400, 100";
          };
        };
      };
    };

    services = {
      # notif daemon
      mako = {
        enable = true;
        settings = {
          max-history = 10;
          default-timeout = 5000;
          anchor = "bottom-right";
        };
      };

      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "hyprlock";
            before_sleep_cmd = "hyprlock";
            after_sleep_cmd = "hyprlock";
          };

          listener = [
            {
              timeout = 300;
              on-timeout = "hyprlock";
            }
            {
              timeout = 900;
              on-timeout = "systemctl sleep";
            }
          ];
        };
      };
    };
  };
}