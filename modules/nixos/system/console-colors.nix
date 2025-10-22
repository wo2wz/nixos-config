{ config, lib, ... }:

{
  console.colors =
  let
    toRgb = color: lib.removePrefix "#" color;

    colors = config.custom.colors;
  in [
    (toRgb colors.base00)
    (toRgb colors.base08)
    (toRgb colors.base0C)
    "b58900"
    "268bd2"
    "d33682"
    "2aa198"
    (toRgb colors.base05)
    (toRgb colors.base0D)
    (toRgb colors.base08)
    (toRgb colors.base0C)
    "657b83"
    "839496"
    "6c71c4"
    "93a1a1"
    (toRgb colors.base07)
  ];
}