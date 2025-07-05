let
  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_STATE_HOME = "$HOME/.local/state";
  XDG_BIN_HOME = "$HOME/.local/bin";
  XDG_RUNTIME_DIR = "/run/user/$UID";
in
{
  simple = {
    dataHome = XDG_DATA_HOME;
    configHome = XDG_CONFIG_HOME;
    cacheHome = XDG_CACHE_HOME;
  };

  # Global env
  golbal = {
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
}
