{
  lib,
  config,
  ...
}:
{
  systemd = {
    /* settings.Manager ={      
      DefaultTimeoutStartSec = "15s";
      DefaultTimeoutStopSec = "15s";
      DefaultTimeoutAbortSec = "15s";
      DefaultDeviceTimeoutSec = "15s";
    };

    user.extraConfig = ''
      DefaultTimeoutStartSec=15s
      DefaultTimeoutStopSec=15s
      DefaultTimeoutAbortSec=15s
      DefaultDeviceTimeoutSec=15s
    ''; */

    services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
      "getty@tty7".enable = false;
      "autovt@tty7".enable = false;
      "kmsconvt@tty1".enable = false;
      "kmsconvt@tty7".enable = false;
      "serial-getty@".environment.TERM = "xterm-256color";
      NetworkManager-wait-online.enable = false;
      nix-daemon.serviceConfig.OOMScoreAdjust = lib.mkDefault 350;
    };

    # Systemd OOMd
    # Fedora enables these options by default. See the 10-oomd-* files here:
    # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
    oomd = {
      enable = lib.mkDefault true;
      enableRootSlice = true;
      enableUserSlices = true;
      enableSystemSlice = true;
      settings.OOM = {
        "DefaultMemoryPressureDurationSec" = "20s";
      };
    };

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
