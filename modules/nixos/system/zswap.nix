{ config, ... }:

{
  boot.kernelParams =
  # zswap needs a swapfile
  assert config.swapDevices != [];
  [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.max_pool_percent=25"
    "zswap.shrinker_enabled=1"
  ];
}