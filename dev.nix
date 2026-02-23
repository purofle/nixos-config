{ pkgs, ... }:

{

  imports = [
    ./programs/python.nix
    ./programs/git.nix
    ./programs/1password.nix
  ];

  home.packages = with pkgs; [
    gh
    lazygit
    kdePackages.kleopatra
    pre-commit
    jetbrains.pycharm
    jetbrains.webstorm
    jetbrains.idea
    pnpm
    nodejs
    rustup
    rustPlatform.bindgenHook
    gcc
  ];

  programs.ssh.enable = true;
}
