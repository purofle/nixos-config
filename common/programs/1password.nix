{
  config,
  lib,
  pkgs,
  ...
}:

let
  darwinSockPath = "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  linuxSockPath = "${config.home.homeDirectory}/.1password/agent.sock";
  agentSockPath = if pkgs.stdenv.hostPlatform.isDarwin then darwinSockPath else linuxSockPath;
in

{
  programs.git.signing = {
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnOUTy30lbNXW15Zt35RpCEtaSubMgyl+zOHv4RnNGQ";
    format = "ssh";
    signer = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
    signByDefault = true;
  };

  programs.ssh.extraConfig = ''
    Host *
        IdentityAgent "${agentSockPath}"
  '';
}
