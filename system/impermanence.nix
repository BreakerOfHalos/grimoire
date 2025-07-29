{  pkgs
, lib
, config
, ...
}:
let
  sources = import ../../npins;
  # impermanence = import sources.impermanence;

  cfg = config.grimoire.system.impermanence;
in
{
  imports = [ "${sources.impermanence}/nixos.nix" ];

  options.grimoire.system.impermanence = {
    enable = lib.mkEnableOption "Turn on impermanence settings for the system.";
    workstationPersistence = lib.mkEnableOption "Set up the standard persistent files for a workstation.";

    extraPersistentDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = lib.options.literalExpression "[ "/var/lib/bluetooth" ]";
      description = "Extra directories to persist on this system.";
    };

    extraPersistentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = lib.options.literalExpression "[ "/etc/ssh/ssh_host_rsa_key.pub" ]";
    };
  };

  config = lib.mkIf cfg.enable {
  boot.initrd.systemd = {
    enable = true;
    services.rollback = {
      description = "Rollback BTRFS root subvvolume to a pristine state.";
      wantedBy = [ "initrd.target" ];

      # LUKS/TPM process. If you have named your device mapper something other
      # than 'crypted', then @cypted will have a different name. Adjust accordingly.
      after = [ "me @ domain" ];

      # Before mounting the system root (/sysroot) during the early boot process.
      before = [ "sysroot.mount" ];

      unitConfig.DefaultDependencies = "no";
      serviceConfigType = "oneshot";
      script = ''
        mkdir -p /mnt

        # We first mount the BTRFS root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount -o subvol=/ /dev/mapper/crypted /mnt

        # While we're tempted to just delete /root and create
        # a new snapshot from /root-blank, /root is already
        # populated at this point with a number of subvolumes,
        # which makes `btrfs subvolume delete` fail.
        # So, we remove them first.
        #
        # /root contains subvolumes:
        # - /root/var/lib/portables
        # - /root/var/lib/machines

        btrfs subvolume list -o /mnt/root |
          cut -f9 -d' ' |
          while read subvolume; do
            echo "deleting /$subvolume subvolume..."
            btrfs subvolume delete "/mnt/$subvolume"
          done &&
          echo "deleting /root subvolume..." &&
          btrfs subvolume delete /mnt/root
        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        # Once we're done rolling back to a blank snapshot,
        # we can unmount /mnt and continue on the boot process.
        umount /mnt
      '';
    };
  };
  
    environment.persistence."/persist" = lib.mkMerge [
      (lib.mkIf cfg.workstationPersistence {
        directories = [
          "/etc/nixos"
          "/etc/NetworkManager/system-connections"
          "/etc/secureboot"
          "/var/db/sudo"
          "/etc/wireguard"
          "/var/lib/bluetooth"
        ];

        files = [
          "/etc/machine-id"

          # Required for SSH. If you have keys with different algorithms. then
          # you must also persist them here.
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"

          # If you have Docker or LXD, also persist their directories.
        ];
      })

      ({
        directories = [
          cfg.extraPersistentDirectories
        ];
      })

      ({
        files = [
          cfg.extraPersistentFiles
        ];
      })
    ];
  };
}
