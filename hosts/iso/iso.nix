{ lib 
, config
, pkgs
, ... 
}:
let
  sources = ../../npins;
  disko = sources.disko;
  lix-module = sources.lix-module;
  lixSrc = sources.lixSrc;

  # Get the hostname from our networking name provided in the mkNixosIso builder
  # If none is set then default to "nixos"
  hostname = config.networking.hostName or "nixos";

  # Give all the isos a consistent name
  # $hostname-$release-$rev-$arch
  name = "${hostname}-${config.system.nixos.release}-${pkgs.stdenv.hostPlatform.uname.processor}";
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>

    (import "${lix-module}/module.nix" { lix = lixSrc; })
    "${disko}/module.nix"
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowAliases = false;
    };
  };

  environment.systemPackages = [ 
    pkgs.helix
    pkgs.nixos-facter 
    pkgs.pciutils
  ];

  # disable documentation
  documentation = {
    enable = mkDefault false;
    doc.enable = mkDefault false;
    info.enable = mkDefault false;
  };

  # we don't need this, plus it adds extra programs to the iso
  services = {
    logrotate.enable = false;
    udisks2.enable = false;
  };

  # disable fontConfig
  fonts.fontconfig.enable = mkForce false;

  # disable containers as it also pulls in pearl
  boot.enableContainers = false;

  programs = {
    # disable less as it pulls in pearl
    less.lessopen = null;

    # disable command-not-found and other similar programs
    command-not-found.enable = false;
  };

  # Use environment options, minimal profile
  environment = {
    # we don't really need this warning on the minimal profile
    stub-ld.enable = mkForce false;

    # no packages other, other then the ones I provide
    defaultPackages = [ ];
  };

  xdg = {
    autostart.enable = false;
    icons.enable = false;
    mime.enable = false;
    sounds.enable = false;
  };

  hardware.enableRedistributableFirmware = true;

  # use networkmanager in the live environment
  networking.networkmanager = {
    enable = true;
    # we don't want any plugins, they only takeup space
    # you might consider adding some if you need a VPN for example
    plugins = lib.mkForce [ ];
  };

# We don't want to alter the iso image itself so we prevent rebuilds
  system.switch.enable = false;

  # fixes "too many open files"
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = "65536";
    }
  ];

  # fix annoying warnings
  environment.etc = {
    "nix/flake-channels/nixpkgs".source = sources.nixpkgs;

    "mdadm.conf".text = ''
      MAILADDR root
    '';
  };

  isoImage = {
    # volumeID is used is used by stage 1 of the boot process, so it must be distintctive
    volumeID = lib.mkImageMediaOverride name;

    # maximum compression, in exchange for build speed
    squashfsCompression = "zstd -Xcompression-level 19";

    # ISO image should be an EFI-bootable volume
    makeEfiBootable = true;

    # ISO image should be bootable from USB
    makeUsbBootable = true;

    # remove "-installer" boot menu label
    appendToMenuLabel = "";

    contents = [
      {
        # This should help for debugging if we ever get an unbootable system and have to
        # prefrom some repairs on the system itself
        source = pkgs.memtest86plus + "/memtest.bin";
        target = "/boot/memtest.bin";
      }
      {
        # we also provide our flake such that a user can easily rebuild without needing
        # to clone the repo, which needlessly slows the install process
        source = lib.cleanSource "../../.";
        target = "/config";
      }
    ];
  };

  nix = {

    # we can disable channels since we can just use the flake
    channel.enable = false;

    # we need to have nixpkgs in our path
    nixPath = [ "nixpkgs=${config.nix.registry.nixpkgs.to.path}" ];

    settings = {
      # these are the bare minimum settings required to get my nixos config working
      experimental-features = [
        "flakes"
        "nix-command"
      ];

      # more logging is nice when doing installs, we want to know if something goes wrong
      log-lines = 50;

      # A unimportant warning in this case
      warn-dirty = false;

      # Its nice to have more http downloads when setting up
      http-connections = 50;

      # We can ignore the flake registry since we won't be using it
      # this is because we already have all the programs we need in the ISO
      flake-registry = "";

      # we don't need this nor do we want it
      accept-flake-config = false;

      # this is not important when your in a ISO
      auto-optimise-store = false;

      # fetch from a cache if we can
      substituters = [
        "https://nix-community.cachix.org" # nix-community cache
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
