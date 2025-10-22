{ config, ... }:

{
  boot = {
    # necessary for lz4 compressor
    initrd.systemd.enable = true;

    kernelParams =
    # zswap needs a swapfile
    assert config.swapDevices != [];
    [
      "zswap.enabled=1"
      "zswap.compressor=lz4"
      "zswap.max_pool_percent=25"
      "zswap.shrinker_enabled=1"
    ];
  };
}