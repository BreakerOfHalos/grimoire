{ lib
, pkgs
, ... }:
let
  user = "breakerofhalos";

  sources = import ../../npins;
  npinsSources = import (sources.npins + "/npins");
  npinsPkgs = import npinsSources.nixpkgs { };
  pkgs = import sources.nixpkgs {};
  disko = sources.disko;
  nix-maid = import sources.nix-maid;
  nixos-facter-modules = sources.nixos-facter-modules;
  lix-module = sources.lix-module;
  lixSrc = sources.lixSrc;
in
{
  npinsPkgs.callPackage (sources.npins + "/npins.nix") {}

  imports = [
    (import "${lix-module}/module.nix" { lix = lixSrc; })
    "${disko}/module.nix"
    "${nixos-facter-modules}/modules/nixos/facter.nix"
    nix-maid.nixosModules.default
    ../../modules/maid
  ];

  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  system.stateVersion = "25.05";
  system.stateVersion = "24.11";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = lib.mkDefault "America/Los_Angeles";
  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;
  fonts.enableDefaultPackages = true; 
  facter.reportPath = ./facter.json;

  nixpkgs = {
    flake.source = sources.nixpkgs;
    config.allowUnfree = true;
  };

  programs = {
    fish.enable = true;
  }

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      uutils-coreutils-noprefix
      ;
  };

  users.users.${user} = {
    uid = 1000;
    isNormalUser = true;

    home = "/home/${user}";

    shell = pkgs.fish;

    extraGroups = [
      "wheel"
      "nix"
    ];

    packages = builtins.attrValues {
      inhert (pkgs)
        jaq
        starship
        zoxide
        eza
        yazi
        fzf
        helix
        discordo
        nix-your-shell
        nil
        nixpkgs-fmt
        ;
    };
  };
}