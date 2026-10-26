{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.kleopatra
    jetbrains.pycharm
    jetbrains.webstorm
    jetbrains.idea
    jetbrains.goland
    android-studio
    virt-manager
  ];
}
