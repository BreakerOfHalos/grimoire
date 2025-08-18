{ ... }:
{
  imports = [
    ./boot
    ./nixpkgs.nix
    ./core.nix
    ./security
    ./hardware.nix
    ./nix.nix
    ./profiles
    ./users.nix
    ./system
    ./networking
  ];

}
