{ lib, ... }:
{
  imports = [ ./earlyoom.nix ];
  
  services = {
    # monitor and control temperature
    thermald.enable = true;

    # enable smartd monitoering
    smartd.enable = true;

    # Not using lvm
    lvm.enable = lib.mkDefault false;

    # limit systemd journal size
    # https://wiki.archlinux.org/title/Systemd/Journal#Persistent_journals
    journald.extraConfig = ''
      SystemMaxUse=100M
      RuntimeMaxUse=50M
      SystemMaxFileSize=50M
    '';
  };
}
