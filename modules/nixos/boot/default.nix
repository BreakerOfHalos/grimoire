{ lib
, pkgs
, config
, ... }:
{
  imports = [
    # keep-sorted start
    ./generic.nix # generic boot configuration
    ./loader.nix # which system loader are we using
    # keep-sorted end
  ];
}