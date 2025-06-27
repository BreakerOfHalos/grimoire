{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkForce
    optionals
    optionalAttrs
    ;

  sys = config.grimoire.system;
in
{
  grimoire.packages = optionalAttrs config.grimoire.profiles.graphical.enable {
    inherit (pkgs) networkmanagerapplet; # provides nm-connection-editor
  };

  networking.networkmanager = {
    enable = true;
    plugins = mkForce (
      optionals config.grimoire.profiles.graphical.enable [ pkgs.networkmanager-openvpn ]
    );
    dns = "systemd-resolved";
    unmanaged = [
      "interface-name:tailscale*"
      "interface-name:br-*"
      "interface-name:rndis*"
      "interface-name:docker*"
      "interface-name:virbr*"
      "interface-name:vboxnet*"
      "interface-name:waydroid*"
      "type:bridge"
    ];

    wifi = {
      # this can be iwd or wpa_supplicant, use wpa_s until iwd support is stable
      backend = sys.networking.wirelessBackend;

      # The below is disabled as my uni hated me for it
      macAddress = "random"; # use a random mac address on every boot, this can scew with static ip
      powersave = true;

      # MAC address randomization of a Wi-Fi device during scanning
      scanRandMacAddress = true;
    };

    # causes server to be unreachable over SSH
    ethernet.macAddress = mkIf (!config.grimoire.profiles.server.enable) "random";
  };
}
