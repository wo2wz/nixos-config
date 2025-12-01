{ inputs, config, pkgs, ... }:

{
  programs = {
    gamemode.enable = true; # performance tuning for games
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };
  environment.systemPackages = with pkgs; [
    gamescope # screen resolution controller for games that have bugs when changing resolution
    (prismlauncher.override {
      # Change Java runtimes available to Prism Launcher
      jdks = [
        jdk8
        graalvmPackages.graalvm-oracle_17
        inputs.nixpkgs-pin.legacyPackages.${pkgs.stdenv.hostPlatform.system}.graalvm-ce
      ];
    })
    alsa-oss # fix audio bug on some instances
  ];
}