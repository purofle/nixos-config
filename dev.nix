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

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = true;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
  };
}
