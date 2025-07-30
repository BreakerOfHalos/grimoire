{ lib
, pkgs
, config
, ... }:
{
  imports = [
    # keep-sorted start
    ./generic.nix # Generic boot configuration.
    ./loader.nix # Which system loader are we using?
    # keep-sorted end
  ];
}