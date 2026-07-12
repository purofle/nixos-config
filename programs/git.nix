{ pkgs, ... }:

{
  home.packages = with pkgs; [
    git-absorb
    git-interactive-rebase-tool
  ];
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "purofle@gmail.com";
        name = "purofle";
      };
      commit = {
        gpgSign = true;
      };
    };
    includes = [
      {
        condition = "gitdir:~/work/";
        path = "~/work/.gitconfig";
      }
    ];
    settings = {
      sequence.editor = "${pkgs.git-interactive-rebase-tool}/bin/interactive-rebase-tool";
      absorb.maxStack = 500;
    };
  };
}
