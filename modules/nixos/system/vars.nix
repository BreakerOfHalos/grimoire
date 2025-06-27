{
  lib,
  _class,
  config,
  ...
}:
let
  inherit (lib.types) str;

  sys = config.grimoire.system;
in
{
  options.grimoire.environment.flakePath = { 
    type = str;
    default = "/home/.config/flake";
    description = "The path to the configuration";
  };

  config.environment.variables = {
    SYSTEMD_PAGERSECURE = "true";

    # Some programs like `nh` use the FLAKE env var to determine the flake path
    FLAKE = config.grimoire.environment.flakePath;
    NH_FLAKE = config.grimoire.environment.flakePath;
  };
}
