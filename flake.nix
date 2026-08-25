{
  description = "purofle's Nix Flake";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://cache.nixos.org"
    ];

  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    daeuniverse.url = "github:daeuniverse/flake.nix";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      commonModules = import ./common;
      lib = inputs.nixpkgs.lib;
    in
    {
      nixosConfigurations."nixos" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          commonModules
          ./hosts/nixos

          inputs.home-manager.nixosModules.home-manager
          inputs.daeuniverse.nixosModules.daed
          inputs.nur.modules.nixos.default
          {
            nixpkgs.overlays = [ inputs.nur.overlays.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.backupFileExtension = "backup";
            home-manager.users.purofle = ./hosts/nixos/home.nix;
          }
        ];
        specialArgs = {
          inherit inputs;
        };
      };

      darwinConfigurations."Mac-mini" = inputs.nix-darwin.lib.darwinSystem {
        modules = [
          commonModules
          ./hosts/darwin

          inputs.home-manager.darwinModules.home-manager
          inputs.nur.modules.darwin.default
          {
            nixpkgs.overlays = [ inputs.nur.overlays.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.backupFileExtension = "backup";
            home-manager.users.purofle = ./hosts/darwin/home.nix;
          }
        ];
        specialArgs = {
          inherit inputs;
        };
      };

      formatter = lib.genAttrs systems (system: inputs.nixpkgs.legacyPackages.${system}.nixfmt);
      devShells = lib.genAttrs systems (system: {
        rust = import ./develop/rust.nix {
          inherit system;
          pkgs = import inputs.nixpkgs { inherit system; };
        };
      });
    };
}
