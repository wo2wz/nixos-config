{ inputs, config, pkgs, ... }:

let
  nixpkgs-unstable = import inputs.nixpkgs-unstable {
    system = "${pkgs.system}";
    config.allowUnfree = true;
  };
in {
  programs = {
    gamemode.enable = true; # performance tuning for games
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };
  environment.systemPackages = with pkgs; [
    gamescope # screen resolution controller for games that have bugs when changing resolution
    alsa-oss # to fix minecraft audio jank
    (prismlauncher.override {
      # Change Java runtimes available to Prism Launcher
      jdks = [
        jdk8
        nixpkgs-unstable.graalvmPackages.graalvm-oracle_17
        inputs.nixpkgs-pin.legacyPackages.${pkgs.system}.graalvm-ce
      ];
    })
  ];
}