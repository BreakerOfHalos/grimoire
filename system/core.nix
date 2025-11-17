{ lib
, pkgs
, config
, ... }:
{
  system.stateVersion = "25.05";

  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = lib.mkDefault "America/Los_Angeles";

  fonts.enableDefaultPackages = true;

  hardware.graphics.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      # CLI base tools
      libnotify
      nautilus
      networkmanagerapplet
      pciutils
      rage
      usbutils
      uutils-coreutils-noprefix
      xdg-utils
    ;
  };

  programs = {
    # We need dconf to interact with gtk
    dconf.enable = true;

    # GNOME's keyring manager
    seahorse.enable = true;
  };

  services = {
    # Disable chrony in favor of systemd-timesyncd
    timesyncd.enable = lib.mkDefault true;
    chrony.enable = lib.mkDefault false;

    # Enable GVFS a userspace virtual filesystem
    gvfs.enable = true;

    # Storage daemon required for udiskie auto-mount
    udisks2.enable = true;

    udev.packages = [ pkgs.gnome-settings-daemon ];

    dbus = {
      enable = true;
      # Use the faster dbus-broker instead of the classic dbus-daemon
      implementation = "broker";

      packages = builtins.attrValues { inherit (pkgs) dconf gcr udisks; };
    };

    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = ["/"];
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
}  
