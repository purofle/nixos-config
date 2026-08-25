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
    pre-commit
    pnpm
    nodejs
    rustup
    rustPlatform.bindgenHook
    gcc
    zulu
    jq
    go
    ripgrep
    kitty
    tmux
    zellij
    jujutsu
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
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
