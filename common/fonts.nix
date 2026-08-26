{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    sarasa-gothic
    nerd-fonts.jetbrains-mono
    jetbrains-mono
  ];
}
