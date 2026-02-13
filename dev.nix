{ lib, pkgs, ... }:

{

  imports = [
    ./python.nix
  ];

  home.packages = with pkgs; [
    gh
    lazygit
    kdePackages.kleopatra
    pre-commit
    jetbrains.webstorm
    pnpm
    nodejs
  ];

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.git = {
    enable = true;
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnOUTy30lbNXW15Zt35RpCEtaSubMgyl+zOHv4RnNGQ";
      format = "ssh";
      signer = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      signByDefault = true;
    };
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
  };
}
