{
  nixpgks,
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

          lix-module.nixosModules.default

          hjem.nixosModules.default

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