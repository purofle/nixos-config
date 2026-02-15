{ lib, pkgs, ... }:

{
  programs.git.signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnOUTy30lbNXW15Zt35RpCEtaSubMgyl+zOHv4RnNGQ";
      format = "ssh";
      signer = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      signByDefault = true;
    };

  programs.ssh.extraConfig = ''
      Host *
          IdentityAgent ~/.1password/agent.sock
    '';
}