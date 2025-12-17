{ inputs, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common

    ../../modules/nixos/programs/desktop/niri
    ../../modules/nixos/programs/desktop/niri/niri/window-rules/single-monitor.nix
    ../../modules/nixos/programs/desktop/niri/niri/workspaces/single-monitor.nix

    ../../modules/nixos/programs/bash.nix
    ../../modules/nixos/programs/gaming.nix
    ../../modules/nixos/programs/scrcpy.nix

    ../../modules/nixos/services/syncthing
    ../../modules/nixos/services/syncthing/main.nix
    ../../modules/nixos/services/tailscale
    ../../modules/nixos/services/tailscale/exit-node/client.nix
    
    ../../modules/nixos/system/colors.nix
    ../../modules/nixos/system/console-colors.nix
    ../../modules/nixos/system/desktop.nix
    ../../modules/nixos/system/fonts.nix
    ../../modules/nixos/system/home-manager.nix
    ../../modules/nixos/system/laptop.nix
    ../../modules/nixos/system/printing.nix
    ../../modules/nixos/system/scx.nix
    ../../modules/nixos/system/swap.nix
    ../../modules/nixos/system/yubikey.nix
    ../../modules/nixos/system/zswap.nix

    inputs.nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
  ];

  # boot option to disable the dgpu for power saving
  # also the longest one-line option name in this config
  specialisation.disable-dgpu.configuration.hardware.nvidiaOptimus.disable = true;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;

    nvidiaSettings = false;
  };

  environment.etc."Yubico/u2f_keys".text = "wo2w:RFdNibvUq8C38apD6K7kw116TfPBBbOf1PdQJrpAtorqV9JGvOTvVK71BR0CvlFCQ8/i+Dr/9D+H3QX5XIy+4g==,Q/N8eJG6lqrczqZQOZ1/Q956ufeORn4GlXuD//IC9swlbohg7lg1bF7wxJ1e8w66hb+vvoCrTrE0wTlbtsEbCw==,es256,+presence";

  # necessary to make the camera not look like the sun
  environment.systemPackages = [ pkgs.cameractrls ];

  home-manager.users.wo2w = {
    imports = [
      ../../modules/home
    ];

    # fix screen tearing in games
    programs.niri.settings.debug.wait-for-frame-completion-before-queueing = {};

    programs.btop = {
      package = pkgs.btop-cuda;
      settings = {
        shown_boxes = "cpu mem net proc gpu0";
        custom_cpu_name = "Core i7-8750H";
      };
    };

    home.file = {
      ".local/share/applications/com.dec05eba.gpu_screen_recorder.desktop".text = ''
        [Desktop Entry]
        Categories=AudioVideo;Recorder;
        Comment[en_US]=A gpu based screen recorder / streaming program
        Comment=A gpu based screen recorder / streaming program
        Exec=nvidia-offload gpu-screen-recorder-gtk
        GenericName[en_US]=Screen recorder
        GenericName=Screen recorder
        Icon=com.dec05eba.gpu_screen_recorder
        Keywords=gpu-screen-recorder;screen recorder;streaming;twitch;replay;
        MimeType=
        Name[en_US]=GPU Screen Recorder
        Name=GPU Screen Recorder
        Path=
        StartupNotify=true
        Terminal=false
        TerminalOptions=
        Type=Application
        X-KDE-SubstituteUID=false
        X-KDE-Username=
      '';

      ".local/share/applications/vesktop.desktop".text = ''
        [Desktop Entry]
        Categories=Network;InstantMessaging;Chat
        Exec=nvidia-offload vesktop %U
        GenericName=Internet Messenger
        Icon=vesktop
        Keywords=discord;vencord;electron;chat
        Name=Vesktop
        StartupWMClass=Vesktop
        Type=Application
        Version=1.4
      '';
    };

    home.stateVersion = "25.05";
  };

  system.stateVersion = "24.11";
}