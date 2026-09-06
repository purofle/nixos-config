{ lib, pkgs, ... }:
{
  imports = [
    ../../dev.nix
    ../../common/programs/zsh.nix
  ];

  home.username = "purofle";
  home.homeDirectory = "/Users/purofle";
  home.stateVersion = "25.11";

  # macOS's generated /etc/zshrc calls compinit unconditionally.  Zim's
  # completion module must be the only initializer.
  programs.zsh.envExtra = lib.mkAfter ''
    export NOSYSZSHRC=1
  '';

  home.packages = [
    pkgs.orbstack
  ];
}
