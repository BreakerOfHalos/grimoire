{ lib }:
let
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

  mkPub = host: key: {
    "${host}-${key.type}" = {
    hostNames = [ host ];
    publicKey = "ssh-${key.type} ${key.key}";
    };
  };

  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_STATE_HOME = "$HOME/.local/state";
  XDG_BIN_HOME = "$HOME/.local/bin";
  XDG_RUNTIME_DIR = "/run/user/$UID";
in
{
  
}
