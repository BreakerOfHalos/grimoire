{ lib
, pkgs
, ... }:
let
  user = "breakerofhalos";
  
  sources = import ../../npins;
  disko = sources.disko;
  nix-maid = sources.nix-maid;
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
      ;
  };
in
{
  imports = [
    "${disko}/module.nix"
    "${nixos-facter-modules}/modules/nixos/facter.nix"
    nix-maid.nixosModules.default
    ./lib.nix
    ./core.nix
    ./graphical.nix
    ./laptop.nix
    ./headless.nix
    ./security.nix
    ./hardware.nix
    ./users.nix
    ./system
    ./networking
  ];
  system.stateVersion = "24.11";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = mkDefault "America/Los_Angeles";
  hardware.bluetooth.enable = lib.mkIf prof.graphical.enable;
  networking.networkmanager.enable = true;
  users.mutableUsers = false;
  fonts.enableDefaultPackages = true;

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

    _1password.enabe = true;
    _1password-gui.enable = true;
    direnv.enable = true;
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
    variables = grimoireLib.xdg-template.global;
    sessionVariables = grimoireLib.xdg-template.user grimoireLib.xdg-template.simple;
  };
}
