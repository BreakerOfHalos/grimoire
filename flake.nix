{
  description = "Trying to be reasonable, and take things one step at a time.";

  outputs = inputs @ {
    nixpkgs, 
    lix-module,
    zen-browser,
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
            pkg.nixfmt
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

      nixosCofigurations = import ./hosts inputs;
    };

    inputs = {
      nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

      lix-module = {
        url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      zen-browser = {
        type = "github";
        owner = "youwen5";
        repo = "zen-browser-flake";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    }
}