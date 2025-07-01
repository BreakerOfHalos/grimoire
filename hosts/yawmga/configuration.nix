{ lib
, config
, pkgs
, ... }:
{
  imports = [
    ../../modules/nixos
    ../../modules/maid
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
