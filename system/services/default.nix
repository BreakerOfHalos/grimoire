{ lib, ... }:
{
  imports = [ ./earlyoom.nix ];

  services = {
    # discard blocks that are not in use by the filesystem, good for SSDs health
    fstrim = {
      enable = true;
      interval = "weekly";
    };

    # clean btrfs devices
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };

    # monitor and control temperature
    thermald.enable = true;

    # enable smartd monitoering
    smartd.enable = true;

    # Not using lvm
    lvm.enable = lib.mkDefault false;

    # limit systemd journal size
    # https://wiki.archlinux.org/title/Systemd/Journal#Persistent_journals
    journald.extraConfig = ''
      SystemMaxUse=100M
      RuntimeMaxUse=50M
      SystemMaxFileSize=50M
    '';
  };
}
