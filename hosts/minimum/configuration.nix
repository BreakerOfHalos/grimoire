{ lib
, pkgs
, ... }:
let
  user = "breakerofhalos";

  sources = import ./npins;
  pkgs = import sources.nixpkgs {};
  disko = sources.disko;
  nix-maid = import sources.nix-maid;
  nixos-facter-modules = sources.nixos-facter-modules;
  lix-module = sources.lix-module;
  lixSrc = sources.lixSrc;
in
{
  imports = [
    (import "${lix-module}/module.nix" { lix = lixSrc; })
    "${disko}/module.nix"
    "${nixos-facter-modules}/modules/nixos/facter.nix"
    nix-maid.nixosModules.default
    ./void-disk-config.nix
  ];

  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  system.stateVersion = "25.05";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = lib.mkDefault "America/Los_Angeles";
  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;
  fonts.enableDefaultPackages = true; 
  facter.reportPath = ./facter.json;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-partlabel/luks";
      allowDiscards = true;
    };
  };

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

  networking= {
    networkmanager.enable = true;
    hostName = "void";
  };

  services.openssh.enable = true;

  programs = {
    fish.enable = true;
  };

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
      inherit (pkgs)
        npins
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