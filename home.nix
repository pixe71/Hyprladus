{ config, pkgs, ... }:

{
  # Change ça par ton vrai pseudo et ton vrai dossier home
  home.username = "nixos"; 
  home.homeDirectory = "/home/nixos";

  # La version de Home Manager (ne change pas ça)
  home.stateVersion = "24.11"; 

  # Ici tu pourras ajouter tes programmes utilisateur plus tard
  home.packages = [
  ];

  # Laisse ça pour que Home Manager fonctionne
  programs.home-manager.enable = true;
}
