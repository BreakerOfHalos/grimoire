{ lib
, pkgs
, config
, ... }:
{
  imports = [
    # keep-sorted start
    ./generic.nix # Generic boot configuration.
    ./loader.nix # Which system loader are we using?
    ./secure-boot.nix # Does what it says on the tin.
    # keep-sorted end
  ];
}