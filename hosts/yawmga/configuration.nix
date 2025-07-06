{ lib
, config
, pkgs
, ... }:
{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  network.hostName = "yawmga";

  grimoire = {
    profiles = {
      graphical.enable = true;
      gaming.enable = true;
    };

    device.capabilities = {
      yubikey = true;
      tpm = true;
     }; 

    system = {
      printing.enable = true;
    };
  };

  facter.reportPath = ./facter.json;
}
