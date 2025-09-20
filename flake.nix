{
  description = "Trying to be reasonable, and take things one step at a time.";

  outputs = inputs @ {
    nixpkgs, 
    ...
  }:
    let
      user = import ./user;

      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ];
    in {
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

      zen-browser = {
        type = "github";
        owner = "youwen5";
        repo = "zen-browser-flake";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
}
