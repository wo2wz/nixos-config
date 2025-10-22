{ config, lib, ... }:

let
  mkVar =
  color:
  lib.mkOption {
    type = lib.types.str;
    default = color;
  };
in {
  options.custom.colors = {
    base00 = mkVar "#17031A";
    base01 = mkVar "#392551";
    base02 = mkVar "#5A496E";
    base03 = mkVar "#7B6D8B";
    base04 = mkVar "#9C92A8";
    base05 = mkVar "#BDB6C5";
    base06 = mkVar "#DEDAE2";
    base07 = mkVar "#FEFFFF";
    base08 = mkVar "#27D9D5";
    base09 = mkVar "#5BA2B6";
    base0A = mkVar "#8F6C97";
    base0B = mkVar "#C33678";
    base0C = mkVar "#F80059";
    base0D = mkVar "#BD0152";
    base0E = mkVar "#82034C";
    base0F = mkVar "#470546";
  };
}