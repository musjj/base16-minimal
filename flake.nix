{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:musjj/stylix/bump-base16";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # FIXME replace with your hostname
        osmium = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          # > Our main nixos configuration file <
          modules = [ ./nixos/configuration.nix ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        # FIXME replace with your username@hostname
        "your-username@your-hostname" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          # > Our main home-manager configuration file <
          modules = [ ./home-manager/home.nix ];
        };
      };
    };
}
