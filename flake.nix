{
  description = "purofle's NixOS Flake";

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
  };

  nixConfig = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://cache.nixos.org"
    ];
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
      inherit system;
    };
    mkHost =
      hostname:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./system
          ./hosts/${hostname}
          inputs.daeuniverse.nixosModules.dae
          inputs.daeuniverse.nixosModules.daed
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ inputs.nur.overlays.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.users.purofle = ./home.nix;
          }
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    in
    {
      formatter.${system} = pkgs.nixfmt;
      devShells.${system}.rust = import ./develop/rust.nix { inherit pkgs; };
      nixosConfigurations.nixos = mkHost "nixos";
    };
}
