{ lib, ... }:

let
  zimModules = [
    "environment"
    "git"
    "input"
    "termtitle"
    "utility"
    "duration-info"
    "git-info"
    "asciiship"
    "zsh-users/zsh-completions --fpath src"
    "completion"
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-history-substring-search"
    "zsh-users/zsh-autosuggestions"
    "Aloxaf/fzf-tab"
  ];

  zimrcContent = lib.concatMapStringsSep "\n" (m: "zmodule ${m}") zimModules;
in
{
  imports = [
    ./dev.nix
    ./programs/zsh.nix
  ];

  home.username = "purofle";
  home.homeDirectory = "/home/purofle";
  home.stateVersion = "25.11";

  home.file.".zimrc".text = zimrcContent + "\n";
}
