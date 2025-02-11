{
    description = "A very basic flake";

    inputs = {

        home-manager = {
            url = "github:nix-community/home-manager/release-24.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixpkgs.url = "nixpkgs/nixos-24.11";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    };

    outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs {
                inherit system;
                config = { allowUnfree = true; };
            };

            pkgs-unstable = import nixpkgs-unstable {
                inherit system;
                config = { allowUnfree = true; };
            };

            lib = nixpkgs.lib;
        in {
            nixosConfigurations = {
                JD-nixos = lib.nixosSystem {
                    inherit system pkgs;
                    modules = [
                        ./configuration.nix
                        ./hardware-configuration.nix
                        home-manager.nixosModules.home-manager
                        {
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;
                            home-manager.users.jd = import ./home.nix;
                            home-manager.extraSpecialArgs = {
                                inherit pkgs-unstable;
                            };

                        }
                    ];
                };
            };
        };
}
