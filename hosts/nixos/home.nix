{
  imports = [
    ../../dev.nix
    ../../dev-linux.nix
    ../../common/programs/zsh.nix
  ];

  home.username = "purofle";
  home.homeDirectory = "/home/purofle";
  home.stateVersion = "25.11";
}
