{
    inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";#surface-flake

    inputs = {

        home-manager = {
            url = "github:nix-community/home-manager/release-24.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixpkgs.url = "nixpkgs/nixos-24.11";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
        nix-gaming.url = "github:fufexan/nix-gaming";
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, nix-gaming, ... }@inputs:
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

                        {
                            virtualisation.docker.enable = true;
                            users.users.jd.extraGroups = [ "docker" ];
                        }
                        
                        nixos-hardware.nixosModules.microsoft-surface-pro-intel
                        # Add osu-stable here
                        {
                            environment.systemPackages = [
                                nix-gaming.packages.${system}.osu-lazer-bin
                            ];
                        }
                    ];
                };
            };
        };
}
