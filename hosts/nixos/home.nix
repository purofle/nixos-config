{ pkgs, ... }:

{
  imports = [
    ../../dev.nix
    ../../dev-linux.nix
    ../../programs/zsh.nix
  ];

  home.username = "purofle";
  home.homeDirectory = "/home/purofle";
  home.stateVersion = "25.11";
}
