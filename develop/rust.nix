{ pkgs, ... }:

pkgs.mkShell {
  packages = with pkgs; [
    rustc
    cargo
    pkg-config
    openssl
  ];

  shellHook = ''
    rustc --version
    cargo --version
    if [[ $- == *i* ]]; then
      exec zsh
    fi
  '';
}