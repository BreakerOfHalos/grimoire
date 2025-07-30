{ config
, lib
, ...
}: 
let
  # This is sioodmy's little home brew impermanence :3
  # see, you don't need any external modules for that
  # I vendored this, and slightly tweaked the code style.
  cfg = config.staypls;

  mkPersistentBindMounts = list:
    lib.mkMerge (builtins.map (
        path: {
          "${path}" = {
            device = "/persist${path}";
            fsType = "none";
            options = [
              "bind"
              # no reason to trim bind mounts like that
              "X-fstrim.notrim"
              # hide the mounts cuz I dont wanna see them
              "x-gvfs-hide"
            ];
          };
        }
      )
      list);
  mkPersistentSourcePaths = list: 
    lib.strings.concatStringsSep "\n" (lib.forEach list (path: "mkdir -p /persist${path}"));
in {
  options.staypls = {
    enable = lib.mkEnableOption "Enable directory impermanence module";
    dirs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of directiories to mount";
    };
  };
  config = lib.mkIf cfg.enable {
    boot.initrd.systemd.enable = lib.mkDefault true;

    fileSystems = mkPersistentBindMounts cfg.dirs;
    boot.initrd.systemd.services.make-source-of-persistent-dirs = {
      wantedBy = ["initrd-root-device.target"];
      before = ["sysroot.mount"];
      requires = ["persist.mount"];
      after = ["persist.mount"];
      serviceConfig.Type = "oneshot";
      unitConfig.DefaultDependencies = false;
      script = mkPersistentSourcePaths cfg.dirs;
    };
  };
}