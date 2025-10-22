{ config, pkgs, ... }:

{
  fonts.packages = [ pkgs.font-awesome ];

  home-manager.users.wo2w.programs.waybar = {
    enable = true;
    systemd.enable = true;

    style =
    let
      colors = config.custom.colors;
    in ''
    @define-color base00 ${colors.base00};
    @define-color base05 ${colors.base05};
    @define-color base03 ${colors.base03};
    @define-color base0E ${colors.base0E};
    
    '' + builtins.readFile ./style.css;
    settings = {
      main = {
        output = [
          "eDP-1"
          "DP-1"
        ];
        layer = "top";
        position = "top";
        height = 35;

        modules-left = [
          "niri/workspaces"
          "niri/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "group/cpu-temp"
          "memory"
          "battery"
          "power-profiles-daemon"
          "backlight"
          "network"
          "pulseaudio"
          "tray"
        ];

        "group/cpu-temp" = {
          orientation = "inherit";
          modules = [
            "temperature"
            "cpu"
          ];
        };

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            code = "";
            fullscreen = "";
            gaming = "";
            vesktop = "";
          };
          all-outputs = true;
        };

        "niri/window" = {
          max-length = 50;
          tooltip = false;
        };

        clock = {
          interval = 1;
          timezone = "America/New_York";
          format = "<b>{:%T}</b>";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "<b>{:%Y-%m-%d}</b>";
          actions = {
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
            on-click-middle = "shift_reset";
          };
        };

        temperature = {
          thermal-zone = 9;
          critical-threshold = 90;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
          tooltip = false;
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };

        memory = {
          interval = 10;
          format = "{used:0.1f}G ";
          format-alt = "{percentage}% ";
          tooltip-format = "{swapUsed}G ";
        };

        battery = {
          states = {
            warning = 40;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        backlight = {
          format = "{percent}% {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
          tooltip = false;
        };

        network = {
          format-wifi = "{ipaddr} ";
          format-ethernet = "{ipaddr} ";
          # long ugly ass string because indented strings insert an extra newline (i do not know how to resolve this)
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n\n{ipaddr}/{cidr}\n{ifname} via {gwaddr}\nstrength: {signalStrength}%\nup: {bandwidthUpBytes} down: {bandwidthDownBytes}";
          tooltip-format-ethernet = "{ipaddr}/{cidr}\n{ifname} via {gwaddr}\nup: {bandwidthUpBytes} down: {bandwidthDownBytes}";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };
      };
    };
  };
}