{ pkgs, ... }:

let
  # Temporary override until nixpkgs provides GoLand 2026.3.
  goland = pkgs.jetbrains.goland.overrideAttrs (oldAttrs: {
    version = "2026.3";
    src = pkgs.fetchurl {
      url = "https://download.jetbrains.com/go/goland-2026.3.tar.gz";
      hash = "sha256-9pgWeRYluzNLHenYDOR6OMCqkJURUYRu6omeGjWhWhk=";
    };
    passthru = oldAttrs.passthru // {
      buildNumber = "263.7307.211";
    };
  });
in
{
  home.packages = with pkgs; [
    kdePackages.kleopatra
    jetbrains.pycharm
    jetbrains.webstorm
    jetbrains.idea
    goland
    android-studio
    virt-manager
    claude-code
  ];
}
