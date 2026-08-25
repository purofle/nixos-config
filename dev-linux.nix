{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.kleopatra
    jetbrains.pycharm
    jetbrains.webstorm
    jetbrains.idea
    virt-manager
  ];
}
