{ lib, config, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf (!config.grimoire.profiles.headless.enable) {
    # limit systemd journal size
    # https://wiki.archlinux.org/title/Systemd/Journal#Persistent_journals
    services.journald.extraConfig = ''
      SystemMaxUse=100M
      RuntimeMaxUse=50M
      SystemMaxFileSize=50M
    '';
  };
}
