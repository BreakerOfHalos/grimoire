{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.grimoire.system.boot;
in
{
  options.grimoire.system.boot = {
    enableKernelTweaks = lib.mkEnableOption "Security and performance related kernel parameters";
    recommendedLoaderConfig = lib.mkEnableOption "Tweaks for common bootloader configs per my liking";
    loadRecommendedModules = lib.mkEnableOption "Kernel modules that accomodate most use cases.";
    tmpOnTmpfs = 
      lib.mkEnableOption "`/tmp` living on tmpfs. `false` means that it will be cleared manually on each reboot"
      // {
        default = true;
      };

    kernel = lib.mkOption {
      type = lib.type.raw;
      default = pkgs.linuxPackages_latest;
      description = "The kernel to use for the system.";
    };

    initrd = {
      enableTweaks = lib.mkEnableOption "Quality of life tweaks for the initrd stage.";
      optimizeCompressor = lib.mkEnableOption ''
        initrd compression algorithm for size.
        Enabling this option will force initrd to use zstd (default) with
        level 19 and -T0 (STDIN). This will reduce the initrd size greatly
        at the cost of compression speed.
        Not recommended for low-end hardware.
      '';
    };

    silentBoot = lib.mkEnableOption ''
      Almost entirely silent boot process through the `quiet` kernel parameter.
    '';

    extraKernelParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra kernel parameters to be passed to the kernel.
        This is useful for passing additional parameters to the kernel
        that are not covered by the default parameters.
      ''
    };

    extraModulePackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.options.literalExpression ''With config.boot.kernelPackages; [acpi_call]'';
      description = "Extra kernel modules to be loaded.";
    };
  };

  config = {
    boot = {
      consoleLogLevel = 3;

      # we set the kernel to be defaulted to the one set by our settings
      # we happen to default this to the latest kernel sooo:
      # always use the latest kernel, love the unstablity
      kernelPackages = lib.mkOverride 500 cfg.kernel;

      extraModulePackages = lib.mkDefault cfg.extraModulePackages;

      # whether to enable support for Linux MD RAID arrays
      # as of 23.11>, this throws a warning if neither MAILADDR nor PROGRAM are set
      swraid.enable = mkDefault false;

      # shared config between bootloaders
      # they are set unless system.boot.loader != none
      loader = {
        # if set to 0, space needs to be held to get the boot menu to appear
        timeout = mkForce 2;

        # copy boot files to /boot so that /nix/store is not required to boot
        # it takes up more space but it makes my messups a bit safer
        generationsDir.copyKernels = true;

        # we need to allow installation to modify EFI variables
        efi.canTouchEfiVariables = true;
      };

      # increase the map count, this is important for applications that require a lot of memory mappings
      # such as games and emulators
      kernel.sysctl."vm.max_map_count" = 2147483642;

      # If you have a lack of ram, you should avoid tmpfs to prevent hangups while compiling
      tmp = {
        # /tmp on tmpfs, lets it live on your ram
        useTmpfs = cfg.tmpOnTmpfs;

        # If not using tmpfs, which is naturally purged on reboot, we must clean
        # we have to clean /tmp
        cleanOnBoot = mkDefault (!config.boot.tmp.useTmpfs);

        # this defaults to 50% of your ram
        # but i want to build code sooo
        # tmpfsSize = mkDefault "75%";

        # enable huge pages on tmpfs for better performance
        tmpfsHugeMemoryPages = "within_size";
      };

      initrd = lib.mkMerge [
        (lib.mkIf cfg.initrd.enableTweaks {
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
        })

        (lib.mkIf cfg.initrd.optimizeCompressor {
          compressor = "zstd";
          compressorArgs = [
            "-19"
            "-T0"
          ];
        })
      ];

      kernelParams = 
        lib.lists.optionals cfg.enableKernelTweaks [
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
        ]
        ++ lib.lists.optionals cfg.silentBoot [
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
        ]
    };
  };
}                             