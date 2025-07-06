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
      monitors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          this does not affect any drivers and such, it is only necessary for
          declaring things like monitors in window manager configurations
          you can avoid declaring this, but I'd rather if you did declare
        '';
      };

      capabilities = {
        tpm = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether the system has TPM support";
        };

        yubikey = lib.mkEnableOption "YukiKey Support";
      };
    };
  };

  config = lib.mkMerge [
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
 
    (lib.mkIf config.grimoire.device.capabilities.tpm {
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
    })

    (lib.mkIf config.grimoire.device.capabilities.yubikey {
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
    })
  ];
}
