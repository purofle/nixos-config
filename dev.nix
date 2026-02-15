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
    jetbrains.webstorm
    jetbrains.idea
    pnpm
    nodejs
  ];

  programs.ssh.enable = true;
}
