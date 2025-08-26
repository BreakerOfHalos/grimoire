{ ... }:
{
  boot.initrd.luks.devices.luksroot = {
    device = "/dev/disk/by-label/NIXCRYPT";
    preLVM = true;
    allowDiscards = true;
    #    crypttabExtraOpts = ["fido2-device=auto" "token-timeout=10"];
  };

  fileSystems."/" = {
    neededForBoot = true;
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    options = ["noatime" "discard" "subvol=@root" "compress=zstd"];
  };

  fileSystems."/nix" = {
    neededForBoot = true;
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    options = ["noatime" "discard" "subvol=@nix" "compress=zstd"];
  };

  fileSystems."/tmp" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    options = ["noatime" "discard" "subvol=@tmp"];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    options = ["noatime" "discard" "subvol=@snapshots" "compress=zstd"];
  };

  fileSystems."/home" = {
    neededForBoot = true;
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    options = ["noatime" "discard" "subvol=@home" "compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vFat";
  };

  #  btrfs filesystem mkswapfile --size 96g --uuid clear /persist/swap
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 96 * 1024;
    }
  ];
}