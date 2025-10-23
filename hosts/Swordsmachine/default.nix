{ inputs, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common

    ../../modules/nixos/programs
    ../../modules/nixos/programs/desktop/niri
    ../../modules/nixos/programs/desktop/niri/niri/window-rules/single-monitor.nix
    ../../modules/nixos/programs/desktop/niri/niri/workspaces/single-monitor.nix

    ../../modules/nixos/services/openssh.nix
    ../../modules/nixos/services/tailscale.nix
    
    ../../modules/nixos/system

    inputs.nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
  ];

  # pin the latest nvidia driver that works because they are so awesome in releasing an update that broke opengl for my 1050ti
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "570.144";
    sha256_64bit = "sha256-wLjX7PLiC4N2dnS6uP7k0TI9xVWAJ02Ok0Y16JVfO+Y=";
    sha256_aarch64 = "sha256-6kk2NLeKvG88QH7/YIrDXW4sgl324ddlAyTybvb0BP0=";
    openSha256 = "sha256-PATw6u6JjybD2OodqbKrvKdkkCFQPMNPjrVYnAZhK/E=";
    settingsSha256 = "sha256-VcCa3P/v3tDRzDgaY+hLrQSwswvNhsm93anmOhUymvM=";
    persistencedSha256 = "sha256-hx4w4NkJ0kN7dkKDiSOsdJxj9+NZwRsZEuhqJ5Rq3nM=";
  };

  environment.etc."Yubico/u2f_keys".text = "wo2w:RFdNibvUq8C38apD6K7kw116TfPBBbOf1PdQJrpAtorqV9JGvOTvVK71BR0CvlFCQ8/i+Dr/9D+H3QX5XIy+4g==,Q/N8eJG6lqrczqZQOZ1/Q956ufeORn4GlXuD//IC9swlbohg7lg1bF7wxJ1e8w66hb+vvoCrTrE0wTlbtsEbCw==,es256,+presence";

  # necessary to make the camera not look like the sun
  environment.systemPackages = [ pkgs.cameractrls ];

  services.printing = {
    enable = true;
    drivers = [ pkgs.cups-brother-hll2375dw ];
  };

  home-manager.users.wo2w = {
    imports = [
      ../../modules/home
    ];

    # fix screen tearing in games
    home-manager.users.wo2w.programs.niri.settings.debug.wait-for-frame-completion-before-queueing = {};

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