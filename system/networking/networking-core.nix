{
  lib,
  config,
  pkgs,
  ...
}:
{
  networking = {
    # generate a host ID by hashing the hostname
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

    # this is setup to use the hostname the system builder provides, this is left here
    # as a note for readers to know this is how it works, and why hostName is never set
    # hostName = "nixos";

    # global dhcp has been deprecated upstream, so we use networkd instead
    # however individual interfaces are still managed through dhcp in hardware configurations
    useDHCP = lib.mkForce false;
    useNetworkd = lib.mkForce true;

    # interfaces are assigned names that contain topology information (e.g. wlp3s0) and thus should be consistent across reboots
    # this already defaults to true, we set it in case it changes upstream
    usePredictableInterfaceNames = lib.mkDefault true;

    # dns
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "9.9.9.9"
    ];

    enableIPv6 = true;

    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openvpn ];
      dns = "systemd-resolved";
      unmanaged = [
        "interface-name:tailscale*"
        "interface-name:docker*"
        "type:bridge"
      ];

      wifi = {
        # The below is disabled as my uni hated me for it
        macAddress = "random"; # use a random mac address on every boot, this can scew with static ip
        powersave = true;

        # MAC address randomization of a Wi-Fi device during scanning
        scanRandMacAddress = true;
      };

      # causes server to be unreachable over SSH
      ethernet.macAddress = "random";
    };
  };
}