{ pkgs
, lib
, config
, ...
}:

{
  boot = {
    consoleLogLevel = 3;

    # we set the kernel to be defaulted to the one set by our settings
    # we happen to default this to the latest kernel sooo:
    # always use the latest kernel, love the unstablity
    kernelPackages = lib.mkOverride 500 cfg.kernel;

    # whether to enable support for Linux MD RAID arrays
    # as of 23.11>, this throws a warning if neither MAILADDR nor PROGRAM are set
    swraid.enable = mkDefault false;

    # increase the map count, this is important for applications that require a lot of memory mappings
    # such as games and emulators
    kernel.sysctl."vm.max_map_count" = 2147483642;

    tmp = {
      # we have to clean /tmp
      cleanOnBoot = true;
    };

    initrd = {
      verbose = false;

      systemd.enable = true;

      kernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "btrfs"
        "sd_mod"
        "dm_mod"
        "bluetooth"
        "btusb"
        "uvcvideo"
      ];

      availableKernelModules = [
        "vmd"
        "usbhid"
        "sd_mod"
        "sr_mod"
        "dm_mod"
        "uas"
        "usb_storage"
        "rtsx_usb_sdmmc"
        "rtsx_pci_sdmmc" # Realtek SD card interface (btw i hate realtek)
        "ata_piix"
        "virtio_pci"
        "virtio_scsi"
        "ehci_pci"
      ];

      compressor = "zstd";
        compressorArgs = [
          "-19"
          "-T0"
        ];
    };

    kernelParams = [
      # https://en.wikipedia.org/wiki/Kernel_page-table_isolation
      # `auto` means kernel will automatically decide the pti state
      "pti=auto" # on || off

      # Disable the intel_idle (it stinks anyway) driver and use acpi_idle instead
      "idle=nomwait"

      # Enable IOMMU for devices used in passthrough and provide better host performance
      "iommu=pt"

      # Disable usb autosuspend
      "usbcore.autosuspend=-1"

      # Disables resume and restores original swap space
      "noresume"

      # allow systemd to set and save the backlight state
      "acpi_backlight=native"

      # prevent the kernel from blanking plymouth out of the fb
      "fbcon=nodefer"

      # disable boot logo
      "logo.nologo"

      # disable the cursor in vt to get a black screen during intermissions
      "vt.global_cursor_default=0"

      # tell the kernel to not be verbose, the voices are too loud
      "quiet"

      # kernel log message level
      "loglevel=3" # 1: system is unusable | 3: error condition | 7: very verbose

      # udev log message level
      "udev.log_level=3"

      # lower the udev log level to show only errors or worse
      "rd.udev.log_level=3"

      # disable systemd status messages
      # rd prefix means systemd-udev will be used instead of initrd
      "systemd.show_status=auto"
      "rd.systemd.show_status=auto"
    ];
  };
}                             