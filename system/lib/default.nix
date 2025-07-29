{ lib }:
let
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

  xdg = {
    simple = {
      dataHome = XDG_DATA_HOME;
      configHome = XDG_CONFIG_HOME;
      cacheHome = XDG_CACHE_HOME;
    };

    # Global env
    global = {
      inherit
        XDG_CONFIG_HOME
        XDG_CACHE_HOME
        XDG_DATA_HOME
        XDG_STATE_HOME
        XDG_BIN_HOME
        XDG_RUNTIME_DIR
        ;
      PATH = [ "$bin" ];
    };

    user =
      xdg:
      let
        data = xdg.dataHome;
        config = xdg.configHome;
        cache = xdg.cacheHome;
      in
      {
        # desktop
        KDEHOME = "${config}/kde";
        XCOMPOSECACHE = "${cache}/X11/xcompose";
        ERRFILE = "${cache}/X11/xsession-errors";
        WINEPREFIX = "${data}/wine";

        # programs
        GNUPGHOME = "${data}/gunpg";
        LESSHISTFILE = "${data}/less/history";
        INPUTRC = "${config}/readline/inputrc";
        MPLAYER_HOME = "${config}/mplayer";
        SQLITE_HISTORY = "${cache}/sqlite_history";

        # programming
        IPYTHONDIR = "${config}/ipython";
        JUPYTER_CONFIG_DIR = "${config}/jupyter";
      };
  };
}
