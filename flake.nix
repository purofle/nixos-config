{
  description = "purofle's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    daeuniverse.url = "github:daeuniverse/flake.nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wechat-4114 = {
      url = "github:NixOS/nixpkgs/pull/505623/head";
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
    trusted-users = [
      "purofle"
    ];
  };

  outputs =
    { nixpkgs, home-manager, wechat-4114, ... }@inputs:
    {
      nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system
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
