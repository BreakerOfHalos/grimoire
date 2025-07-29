{ lib
, pkgs
, config
, ... 
}:
let
  cfg = config.grimoire.system.boot;
in
{
  options.grimoire.system.boot = {
    loader = lib.mkOption {
      type = lib.types.enum [
        "none"
        "systemd-boot"
      ];

      default = "none";

      description = "The bootloader that should be used for the device.";
    };

    memtest = {
      enable = lib.mkEnableOption "memtest86+";
      package = lib.mkPackageOption "memtest86plus" { };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.loader == "none") {
      boot.loader = {
        systemd-boot.enable = lib.mkForce false;
      };
    })

    (lib.mkIf (cfg.loader == "systemd-boot") {
      boot.loader.systemd-boot = {
        enable = lib.mkDefault true;
        configurationLimit = 15;
        consoleMode = lib.mkDefault "max";
        editor = false;
      };
    })

    (lib.mkIf cfg.memtest.enable {
      boot.loader.systemd-boot = {
        extraFiles."efi/memtest86plus/memtest.efi" = "${cfg.boot.memtest.package}/memtest.efi";
        extraEntries."memtest86plus.conf" = ''
          title MemTest86+
          efi   /efi/memtest86plus/memtest.efi
        '';
      };
    })
  ];
}
