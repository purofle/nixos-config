{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    nixfmt
    helix
    gnupg
    htop
    bat
    eza
    vscode
    dust
    file
    doggo
    dig
  ];
}
