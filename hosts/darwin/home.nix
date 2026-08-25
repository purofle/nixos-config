{ pkgs, ... }:

{
  imports = [
    ../../programs/zsh.nix
  ];

  home.username = "purofle";
  home.homeDirectory = "/Users/purofle";
  home.stateVersion = "25.11";
}
