{
  description = "Hyprladus NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    # CORRECTION 1 : Ajout de .follows
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # CORRECTION 3 : Chemin direct si le fichier est à côté
        ./nixos/configuration.nix
        
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          
          # CORRECTION 2 : Remplace 'user' par ton vrai nom d'utilisateur !
          # Si tu n'as pas encore créé de user et que tu es root, commente cette ligne pour l'instant.
          home-manager.users.root = import ./nixos/home.nix;
          
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
