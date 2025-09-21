{
  nixpkgs,
  self,
  ...
}:
let
  inherit (self) inputs;
  mkHost = name: system:
    nixpkgs.lib.nixosSystem {
      modules =
        [
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = system;
          }
          
          disko.nixosModules.disko

          ./${name}
        ]
        ++ builtins.attrValues self.nixosModules;

      specialArgs = {
        inherit inputs;
        theme = (import ../user).theme nixpkgs.legacyPackages.${system};
        flake = self;
      };
    };
in
{
  void = mkHost "void" "x86_64-linux";
  yawmga = mkHost "yawmga" "x86_64-linux";
}
