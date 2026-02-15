{ ... }:


{
  imports = [
    ./dev.nix
    ./programs/zsh.nix
  ];

  home.username = "purofle";
  home.homeDirectory = "/home/purofle";
  home.stateVersion = "25.11";
}
