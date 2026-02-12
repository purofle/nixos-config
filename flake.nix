{
  description = "purofle's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    daeuniverse.url = "github:daeuniverse/flake.nix";
    browser-previews.url = "github:nix-community/browser-previews";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://cache.nixos.org"
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {
      nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system
          ./chrome.nix
          inputs.daeuniverse.nixosModules.dae
          inputs.daeuniverse.nixosModules.daed
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.users.purofle = ./home.nix;
          }
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
}
