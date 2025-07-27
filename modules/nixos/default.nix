{ lib
, pkgs
, config
, grimioreLib
, ... }:
let
  sources = import ../../npins;
  npinsSources = import (sources.npins + "/npins");
  npinsPkgs = import npinsSources.nixpkgs { };
  disko = sources.disko;
  nix-maid = import sources.nix-maid;
  nixos-facter-modules = sources.nixos-facter-modules;
  lix-module = sources.lix-module;
  lixSrc = sources.lixSrc;
  impermanence = sources.impermanence;
in
{
  npinsPkgs.callPackage (sources.npins + "/npins.nix") {};

  imports = [
    (import "${lix-module}/module.nix" { lix = lixSrc; })
    ./boot
    ./nixpkgs.nix
    ./core.nix
    "${disko}/module.nix"
    ./impermanence.nix
    "${nixos-facter-modules}/modules/nixos/facter.nix"
    nix-maid.nixosModules.default
    ./security
    ./hardware.nix
    ./nix.nix
    ./profiles
    ./users.nix
    ./system
    ./networking
  ];

}
