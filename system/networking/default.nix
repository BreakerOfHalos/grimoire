{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkDefault mkForce;
  mkPubs = host: keys: lib.foldl' (acc: key: acc // mkPub host key) { } keys;
in
{
  imports = [
    ./optimise.nix
    ./services.nix
    ./tcpcrypt.nix
  ];

  networking = {
    # generate a host ID by hashing the hostname
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

    # this is setup to use the hostname the system builder provides, this is left here
    # as a note for readers to know this is how it works, and why hostName is never set
    # hostName = "nixos";

    # global dhcp has been deprecated upstream, so we use networkd instead
    # however individual interfaces are still managed through dhcp in hardware configurations
    useDHCP = mkForce false;
    useNetworkd = mkForce true;

    # interfaces are assigned names that contain topology information (e.g. wlp3s0) and thus should be consistent across reboots
    # this already defaults to true, we set it in case it changes upstream
    usePredictableInterfaceNames = mkDefault true;

    # dns
    nameservers = mkIf (!(config ? wsl)) [
      "1.1.1.1"
      "1.0.0.1"
      "9.9.9.9"
    ];

    enableIPv6 = true;

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

      # allow servers to be pinnged, but not our clients
      allowPing = false;

      # make a much smaller and easier to read log
      logReversePathDrops = true;
      logRefusedConnections = false;

      # Don't filter DHCP packets, according to nixops-libvirtd
      checkReversePath = mkForce false;
    };

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

  services.openssh = {
    enable = true;
    startWhenNeeded = true;

    allowSFTP = true;

    banner = ''
      Connected to ${config.system.name} @ ${config.system.stateVersion}

      All conntections to this server are logged. Please disconnect now if you
      are not permitted access.
    '';

    settings = {
      # Don't allow root login
      PermitRootLogin = "no";

      # only allow key based logins and not password
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AuthenticationMethods = "publickey";
      PubkeyAuthentication = "yes";
      ChallengeResponseAuthentication = "no";
      UsePAM = false;

      UseDns = false;
      X11Forwarding = false;

      # Use key exchange algorithms recommended by `nixpkgs#ssh-audit`
      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "sntrup761x25519-sha512@openssh.com"
        "diffie-hellman-group-exchange-sha256"
        "mlkem768x25519-sha256"
        "sntrup761x25519-sha512"
      ];

      # Use Macs recommended by `nixpkgs#ssh-audit`
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];

      # kick out inactive sessions
      ClientAliveCountMax = 5;
      ClientAliveInterval = 60;
    };

    openFirewall = true;
    # the port(s) openssh daemon should listen on
    ports = [ 22 ];

    hostKeys = [
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    # find these with `ssh-keyscan <hostname>`
    knownHosts = lib.mkMerge [
      (mkPubs "github.com" [
        {
          type = "rsa";
          key = "AAAAB3NzaC1yc2EAAAADAQABAAACAQDF5lw8/JU9NdOWkajvUSL+2iklu6xGjZs0VDNsA0Dp2fzWod03M6c8Ynuff3hoUIVXufvKCnsXcz1qo6C1dcX0o0dXDh/Vqwt4TBwBLj8wuPjLF78/BV91S9qDcdVSBjXwb6vDYupiVTxkMdkDTXICbq3OKzoygG4Lo3E06nYUjl/gs+hbWNJW3CxJxVKQyp6CFKVtblIhzUUh5O0byQpOqMrtnmhuRCkJ3xpwxnx8GTjsYCTcopX23ZBxbV2yup5K3Eucw6MFiafmvL7OGPfplIvDEsA8W1fXHvs8yNWpTXagtYFxupgti5sjrzaYp/GIOe6OHxM+c8PgyAdNh1c9xFj1+YZ1YfbixcPhanUmlvyWR/0wgr5MvGHTW6okKRu/d5hVBgEdb4JheCmvZpsub16o1/DHLd6hHO+PeHVVmT/BqTfwsulReIR3CZkD/EniCxKbH3kYcadD4hcNcl+AucZuBCRnC3BYAgSWh3uh02XU5TABggxeDAjfCXfuivF/t0YgTC2/sjqgyKx1z7Vui3ihs99t7CwYz4EElQJ392CT7ml0EKwe0wcWxwBS15Y25fEZDlkkuLsu+PK0jOMoMyXPq1ZcBkMK7hJABYSn5glj0Ngab1SoH+VZBSYF6Q2/9hQdb/KzLSdZqwfoRXgPwERYFhmGVo35qNNYcYrwWQ==";
        }
        {
          type = "ed25519";
          key = "AAAAC3NzaC1lZDI1NTE5AAAAIK2g4va2+22UMzA9CTwpGmtj7GfpNOyeXZOMsitUgkSG";
        }
      ])
    ];
  };
}
