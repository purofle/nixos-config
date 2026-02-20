{ pkgs, ... }:
{
  home.packages = with pkgs; [
    python314
    uv
    python314Packages.osc
  ];
}
