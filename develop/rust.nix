{ pkgs, ... }:

pkgs.mkShell {
  packages = with pkgs; [
    rust
    pkg-config
    openssl
  ];

  shellHook = ''
    rustc --version
    cargo --version
    exec zsh
  '';
}