{ lib
, pkgs
, config
, grimioreLib
, ... }:
let
  user = "breakerofhalos";

  grimoireLib = import ./lib { inherit lib; };
  
  sources = import ../../npins;
  disko = import sources.disko;
  nix-maid = import sources.nix-maid;
  nixos-facter-modules = import sources.nixos-facter-modules;
  lix-module = import sources.lix-module;
  lixSrc = import sources.lixSrc;

  NIX_PATH =
    let
      entries = lib.mapAttrsToList (k: v: k + "=" + v) sources;
    in
    "${lib.concatStringsSep ":" entries}:flake=${sources.nixpkgs}:flake";
  # Near as I can tell, this exposes all the sources in all other modules.
  specialArgs = {
    inherit
      sources
      user
      grimoireLib
      ;
  };
in
{
  imports = [
    ("${lix-module}/module.nix" { lix = "${lixSrc}"; })
    ./boot
    ./nixpkgs.nix
    ./core
    "${disko}/module.nix"
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
