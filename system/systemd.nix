{
  lib,
  config,
  ...
}:
let
  extraConfig = ''
    DefaultTimeoutStartSec=15s
    DefaultTimeoutStopSec=15s
    DefaultTimeoutAbortSec=15s
    DefaultDeviceTimeoutSec=15s
  '';
in
{
  systemd = {
    inherit extraConfig;
    user = { inherit extraConfig; };

    services =
      lib.genAttrs
        [
          "getty@tty1"
          "autovt@tty1"
          "getty@tty7"
          "autovt@tty7"
          "kmsconvt@tty1"
          "kmsconvt@tty7"
        ]
        (_: {
          enable = false;
        });
    services."serial-getty@".environment.TERM = "xterm-256color";

    # Systemd OOMd
    # Fedora enables these options by default. See the 10-oomd-* files here:
    # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
    oomd = {
      enable = mkDefault true;
      enableRootSlice = true;
      enableUserSlices = true;
      enableSystemSlice = true;
      extraConfig = {
        "DefaultMemoryPressureDurationSec" = "20s";
      };
    };

    services.nix-daemon.serviceConfig.OOMScoreAdjust = mkDefault 350;

    tmpfiles.settings."10-oomd-root".w = {
      # Enables storing of the kernel log (including stack trace) into pstore upon a panic or crash.
      "/sys/module/kernel/parameters/crash_kexec_post_notifiers" = {
        age = "-";
        argument = "Y";
      };

      # Enables storing of the kernel log upon a normal shutdown (shutdown, reboot, halt).
      "/sys/module/printk/parameters/always_kmsg_dump" = {
        age = "-";
        argument = "N";
      };
    };
  };
}
