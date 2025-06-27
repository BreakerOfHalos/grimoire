{
  lib,
  pkgs,
  config,
  ...
}:
let
  sys = config.grimoire.system;

  hasBtrfs = (lib.filterAttrs (_: v: v.fsType == "btrfs") config.fileSystems) != { };
in
{
  
  options.grimoire = {
    device = {
      hasBluetooth = lib.mkOption {
        type = bool;
        default = true;
        description = "Whether or not the system has bluetooth support";

      monitors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          this does not affect any drivers and such, it is only necessary for
          declaring things like monitors in window manager configurations
          you can avoid declaring this, but I'd rather if you did declare
        '';
      };

      keyboard = lib.mkOption {
        type = lib.types.enum [
          "us"
        ];
        default = "us";
      };

      hasTPM = lib.mkOption {
        type = bool;
        default = false;
        description = "Whether the system has tpm support";
      };
    };
    
    system.yubikeySupport = {
      enable = lib.mkEnableOption "yubikey support";
    };
    
    system.bluetooth.enable = lib.mkEnableOption "Should the device load bluetooth drivers and enable blueman";
  };

  config = lib.mkMerge [

    { hardware.enableRedistributableFirmware = true; }

    {
      # discard blocks that are not in use by the filesystem, good for SSDs health
      services.fstrim = {
        enable = true;
        interval = "weekly";
      };
    }

    # clean btrfs devices
    (lib.mkIf hasBtrfs {
      services.btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
        fileSystems = [ "/" ];
      };
    })
 
    (lib.mkIf sys.bluetooth.enable {
      grimoire.system.boot.extraKernelParams = [ "btusb" ];

      hardware.bluetooth = {
        enable = true;
        package = pkgs.bluez;
        #hsphfpd.enable = true;
        powerOnBoot = true;
        disabledPlugins = [ "sap" ];
        settings = {
          General = {
            JustWorksRepairing = "always";
            MultiProfile = "multiple";
          };
        };
      };

      # https://wiki.nixos.org/wiki/Bluetooth
      services.blueman.enable = true;
    });

    (lib.mkIf config.grimoire.device.hasTPM {
      security.tpm2 = {
        # enable Trusted Platform Module 2 support
        enable = lib.mkDefault true;

        # enable Trusted Platform 2 userspace resource manager daemon
        abrmd.enable = lib.mkDefault false;

        # set TCTI environment variables to the specified values if enabled
        # - TPM2TOOLS_TCTI
        # - TPM2_PKCS11_TCTI
        tctiEnvironment.enable = lib.mkDefault true;

        # enable TPM2 PKCS#11 tool and shared library in system path
        pkcs11.enable = lib.mkDefault true;
      };

      boot.initrd.kernelModules = [ "tpm" ];
    });

    (lib.mkIf config.grimoire.system.yubikeySupport.enable {
      hardware.gpgSmartcards.enable = true;

      services = {
        pcscd.enable = true;
        udev.packages = [ pkgs.yubikey-personalization ];
      };

      programs = {
        ssh.startAgent = false;

        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };
      };

      # Yubico's official tools
      grimoire.packages = {
        inherit (pkgs)
          yubikey-manager # cli
          # yubikey-manager-qt # gui
          ;
      };
    };
  ];
}
