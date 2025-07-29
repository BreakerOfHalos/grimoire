{ lib
, pkgs
, config
, grimioreLib
, ... }:
let
  sources = import ../../npins;
  disko = sources.disko;
  nixos-facter-modules = sources.nixos-facter-modules;
  lix-module = sources.lix-module;
  lixSrc = sources.lixSrc;
  impermanence = sources.impermanence;
in
{
  imports = [
    (import "${lix-module}/module.nix" { lix = lixSrc; })
    ./boot
    ./nixpkgs.nix
    ./core.nix
    "${disko}/module.nix"
    ./impermanence.nix
    "${nixos-facter-modules}/modules/nixos/facter.nix"
    ./security
    ./hardware.nix
    ./nix.nix
    ./profiles
    ./users.nix
    ./system
    ./networking
  ];

}
