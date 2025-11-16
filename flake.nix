{
  description = "Trying to be reasonable, and take things one step at a time.";

  outputs = inputs @ {
    nixpkgs,
    disko,
    # nixos-facter-modules, 
    ...
  }:
    let
      user = import ./user;

      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    {
      packages = forAllSystems (
        system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
            (user.packages pkgs)
      );

      formatter = forAllSystems (
        system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
            pkgs.nixfmt
      );

      devShells = forAllSystems (
        system: 
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
            {default = user.shell pkgs;}  
      );

      nixosModules = {
        system = import ./system;

        user = user.module;
      }
      // import ./modules;

      nixosConfigurations = import ./hosts inputs;
    };

    inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      #nixos-facter-modules = {
      #  type = "github";
      #  owner = "numtide";
      #  repo = "nixos-facter-modules";
      #};

      helium-browser = {
        type = "github";
        owner = "ominit";
        repo = "helium-browser-flake";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      hjem = {
        url = "github:feel-co/hjem";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      hjem-impure = {
        url = "github:Rexcrazy804/hjem-impure";
        inputs.nixpkgs.follows = "";
        inputs.hjem.follows = "";
      };

      disko = {
        type = "github";
        owner = "nix-community";
        repo = "disko";
        ref = "latest";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
}
