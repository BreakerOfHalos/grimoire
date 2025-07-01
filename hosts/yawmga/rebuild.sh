#!/usr/bin/env bash

cd $(dirname $0)

# assume that if there are no args, you want to switch to the configuration
cmd=${1:-switch}
shift

nixpkgs_pin=$(nix eval --json -f npins | jaq -r 'to_entries | map("\(.key=\(.value))") | join(":")')
nix_path="${pins}:nixos-config=${PWD}/configuration.nix"

# without --fast, nixos-rebuild will compile nix and use the compiled nix to
# evaluate the config, wasting several seconds
sudo env NIX_PATH="${nix_path}" nixos-rebuild "$cmd" --fast "$@"
