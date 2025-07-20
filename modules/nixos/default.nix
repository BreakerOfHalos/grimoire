{ lib
, pkgs
, config
, grimioreLib
, ... }:
let
  sources = import ../../npins;
  disko = sources.disko;
  nix-maid = import sources.nix-maid;
  nixos-facter-modules = sources.nixos-facter-modules;
  lix-module = sources.lix-module;
  lixSrc = sources.lixSrc;
  impermanence = sources.impermanence;
  lanzaboote = sources.lanzaboote;
in
{
  imports = [
    (import "${lix-module}/module.nix" { lix = lixSrc; })
    ./boot
    ./nixpkgs.nix
    ./core.nix
    "${disko}/module.nix"
    lanzaboote.nixosModules.lanzaboote
    impermanence.nixosModules.impermanence
    "${nixos-facter-modules}/modules/nixos/facter.nix"
    nix-maid.nixosModules.default
    ./security.nix
    ./hardware.nix
    ./nix.nix
    ./profiles
    ./users.nix
    ./system
    ./networking
  ];

}
