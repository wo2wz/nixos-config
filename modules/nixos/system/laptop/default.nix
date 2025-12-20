{ config, ... }:

{
  imports = [
    ./auto-cpufreq.nix
    ./logind.nix
  ];
}
