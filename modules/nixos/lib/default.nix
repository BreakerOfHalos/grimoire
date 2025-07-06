{ lib }:
let
  mkPub = host: key: {
    "${host}-${key.type}" = {
    hostNames = [ host ];
    publicKey = "ssh-${key.type} ${key.key}";
    };
  };
in
{
  primaryMonitor = config: builtins.elemAt config.grimoire.device.monitors 0;

  mkProgram =
    pkgs: name: extraConfig:
    lib.attrsets.recursiveUpdate {
      enable = lib.options.mkEnableOption "Enable ${name}";
      package = lib.options.mkPackageOption pkgs name { };
  } extraConfig;

  mkGraphicalService = lib.attrsets.recursiveUpdate {
    Unit.PartOf = [ "graphical-session.target" ];
    Unit.After = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
  };

  ifTheyExist = config: groups: lib.filter (group: lib.hasAttr group config.users.groups) groups;

  mkPubs = host: keys: lib.foldl' (acc: key: acc // mkPub host key) { } keys;

  xdg = import ./xdg.nix;
}
