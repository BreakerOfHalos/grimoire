{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        
        content = {
          type = "gpt";
          partitions = {
            ESP = {
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
                name = "cryptex";
                
                settings = {
                  allowDiscards = true;
                };
                
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/media" = {
                      mountpoint = "/media";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "32G";
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

  swapDevices = [
    {
      device = "/.swapvol/swapfile";
      size = 32 * 1024; # Size in MB (32GB)
    }
  ];
}