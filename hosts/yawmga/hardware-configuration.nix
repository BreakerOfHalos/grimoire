{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/641e6ca6-5ad9-4102-a2b6-7c9da0a57c18";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/41F7-B7B5";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];
}
