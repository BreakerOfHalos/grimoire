{ lib
, pkgs
, config
, grimioreLib
, ... }:
let
  user = "breakerofhalos";

  pkgs = import ../../packages;

  grimoireLib = import ./lib { inherit lib; };
  
  sources = import ../../npins;
  disko = sources.disko;
  nix-maid = import sources.nix-maid;
  nixos-facter-modules = sources.nixos-facter-modules;

  prof = config.grimoire.profiles;

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
    "${disko}/module.nix"
    "${nixos-facter-modules}/modules/nixos/facter.nix"
    nix-maid.nixosModules.default
    ./boot.nix
    ./security.nix
    ./hardware.nix
    ./nix.nix
    ./profiles
    ./users.nix
    ./system
    ./networking
  ];
  system.stateVersion = "24.11";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = lib.mkDefault "America/Los_Angeles";
  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;
  fonts.enableDefaultPackages = true;
  nix.nixPath = [ NIX_PATH ];

  environment.systemPackages = with pkgs; [
    # CLI base tools
      uutils-coreutils-noprefix
      rage
      age-plugin-1p
  ];

  programs = {
    steam = {
      enable = prof.gaming.enable;
    };

    _1password.enable = true;
    _1password-gui.enable = true;
    direnv.enable = true;
    fish.enable = true;
  };

  services = {
    userborn = {
      enable = true;
      # passwordFilesLocation = "/persistent/etc";
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";

    # defaults to 50
    memoryPercent = 90;
  };

  boot.kernel.sysctl = lib.mkIf config.zramSwap.enable {
    # zram is relatively cheap, prefer swap
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    # zram is in memory, no need to readahead
    "vm.page-cluster" = 0;
  };

  environment = {
    variables = grimoireLib.xdg.global;
    sessionVariables = grimoireLib.xdg.user grimoireLib.xdg.simple;
  };
}
