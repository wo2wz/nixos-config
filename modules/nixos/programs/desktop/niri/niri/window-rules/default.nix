{ config, ... }:

{
  home-manager.users.wo2w.programs.niri.settings.window-rules = [
    # block sensitive applications from capture
    {
      matches = [{ title = "^Bitwarden$"; }];
      block-out-from = "screen-capture";
    }
    {
      matches = [{ app-id = "^org.kde.polkit-kde-authentication-agent-1$"; }];
      block-out-from = "screen-capture";
      open-floating = true;
    }

    # fix steam notifs
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

    {
      matches = [{ app-id = "com.dec05eba.gpu_screen_recorder"; }];
      open-floating = false;
    }

    # code
    {
      matches = [{ app-id = "codium"; }];
      open-on-workspace = "code";
    }

    # gaming
    {
      matches = [
        { app-id = "steam"; }
        { title = "^Steam$"; }
      ];
      open-on-workspace = "gaming";
      open-maximized = true;
    }
    {
      matches = [{ app-id = "org.prismlauncher.PrismLauncher"; }];
      open-on-workspace = "gaming";
    }

    # fullscreen
    {
      matches = [
        { app-id = "librewolf"; }
        { title = "^LibreWolf$"; }
      ];
      open-on-workspace = "fullscreen";
      open-maximized = true;
    }
    {
      matches = [{ app-id = "spotify"; }];
      open-on-workspace = "fullscreen";
      open-maximized = true;
    }
  ];
}