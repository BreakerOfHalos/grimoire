let
  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_STATE_HOME = "$HOME/.local/state";
  XDG_BIN_HOME = "$HOME/.local/bin";
  XDG_RUNTIME_DIR = "/run/user/$UID";
in
{
  environment = {
    variables = {
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

    sessionVariables = 
    let
      data = XDG_DATA_HOME;
      config = XDG_CONFIG_HOME;
      cache = XDG_CACHE_HOME;
    in
    {
      # desktop
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