{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
# Change the device name to match the actual hardware
        device = "/dev/vdb";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings.allowDiscards = true;
                passwordFile = "/tmp/secret.key";
                content = {
                  type = "btrfs";
# Change the label after "-L" to match the hostname of the system
                  extraArgs = [ "-L" "nixos" "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "subvol=root"
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/root-blank" = {
                      mountOptions = [
                        "subvol=root-blank"
                        "nodatacow"
                        "noatime"
                      ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "subvol=home"
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "subvol=persist"
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "subvol=nix"
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "subvol=log"
                        "compress=zstd"
                        "noatime"
                      ];
                    };
# Change the swap size to match your RAM * 1.5
                    "/swap" = {
                      mountpoint = "/swap";
                      mountOptions = [
                        "subvol=swap"
                        "noatime"
                        "nodatacow"
                        "compress=no"
                      ];
                      swap.swapfile.size = "96G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  filesystems = {
    "/persist".neededForBoot = true;
    "/var/log".neededForBoot = true;
  };

# Update this with the actual swapfile size  
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 96 * 1024;
    }
  ];
}
