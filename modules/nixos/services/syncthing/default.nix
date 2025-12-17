{ config, ... }:

{
  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        drone = {
          addresses = [ "tcp://100.65.0.1:22000" ];
          id = "CTMJ5KR-H373JVN-5TDZU7H-KKUQBW5-HIXEFXW-7OIM3LV-ZRR4IAE-RZFGDQM";
        };
        earthmover = {
          addresses = [ "tcp://100.64.0.1:22000" ];
          id = "P7OPACI-4VYSXLP-6QU22HW-MTZETV4-TH55DRZ-KGHLFTY-FH6ZSGD-42V5RQN";
        };
        swordsmachine = {
          addresses = [ "tcp://100.64.0.2:22000" ];
          id = "QQVUKFI-24XOQUS-SEPQCJS-FFL3K4A-RPNYYHS-BDLMF2Q-B2BKBFI-2I2D4AU";
        };
      };

      options = {
        urAccepted = -1;
        crashReportingEnabled = false;

        natEnabled = false;
        relaysEnabled = false;
        globalAnnounceEnabled = false;
        localAnnounceEnabled = false;
      };
    };
  };
}