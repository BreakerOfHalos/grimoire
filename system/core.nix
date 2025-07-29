{ lib
, pkgs
, config
, ... }:
let
  sources = import ../../npins;
  
  # NIX_PATH =
  #   let
  #     entries = lib.mapAttrsToList (k: v: k + "=" + v) sources;
  #   in
  #   "${lib.concatStringsSep ":" entries}:flake=${sources.nixpkgs}:flake";
  # Near as I can tell, this exposes all the sources in all other modules.
  specialArgs = {
    inherit
      sources
      ;
  };
in
{
  _module.args = specialArgs;
  system.stateVersion = "25.05";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = lib.mkDefault "America/Los_Angeles";
  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;
  fonts.enableDefaultPackages = true;
  # nix.nixPath = [ NIX_PATH ];

  nixpkgs = {
    flake.source = sources.nixpkgs;
    config.allowUnfree = true;
    overlays = [
      (
        final: prev: {
          npins = final.callPackage (
            sources.npins {
              pkgs = final;
            } + "/npins.nix"
          ) {};
        }
      )
    ];
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      # CLI base tools
      uutils-coreutils-noprefix
      rage
      age-plugin-1p
      npins
      networkmanagerapplet
    ;
  };

  programs = {
    _1password.enable = true;
    direnv.enable = true;
    fish.enable = true;
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
