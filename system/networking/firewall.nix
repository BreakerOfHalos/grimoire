{
  lib,
  pkgs,
  ...
}:
{
  networking = {
    stevenblack = {
      enable = true;
      block = [
        "fakenews"
        "gambling"
        # "porn"
        # "social"
      ];
    };

    firewall = {
      enable = true;
      package = pkgs.iptables;

      allowedTCPPorts = [
        443
        8080
      ];
      allowedUDPPorts = [ ];

      allowedTCPPortRanges = [ ];
      allowedUDPPortRanges = [ ];

      # No one's home.
      allowPing = false;

      # make a much smaller and easier to read log
      logReversePathDrops = true;
      logRefusedConnections = false;

      # Don't filter DHCP packets, according to nixops-libvirtd
      checkReversePath = lib.mkForce false;
    };
  };
}