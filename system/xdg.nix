{
  lib,
  config,
  ...
}:
let
  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_STATE_HOME = "$HOME/.local/state";
  XDG_BIN_HOME = "$HOME/.local/bin";
  XDG_RUNTIME_DIR = "/run/user/$UID";

  browser = [
    "text/html"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/ftp"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
  ];

  code = [
    "application/json"
    "text/english"
    "text/plain"
    "text/x-makefile"
    "text/x-c++hdr"
    "text/x-c++src"
    "text/x-chdr"
    "text/x-csrc"
    "text/x-java"
    "text/x-moc"
    "text/x-pascal"
    "text/x-tcl"
    "text/x-tex"
    "application/x-shellscript"
    "text/x-c"
    "text/x-c++"
  ];

  media = [
    "video/*"
    "audio/*"
  ];

  images = [ "image/*" ];

  associations =
    (lib.genAttrs code (_: [ "helix.desktop" ]))
    // (lib.genAttrs media (_: [ "mpv.desktop" ]))
    // (lib.genAttrs images (_: [ "feh.desktop" ]))
    // (lib.genAttrs browser (_: [ "librewolf.desktop" ]))
    // {
      "x-scheme-handler/spotify" = [ "spotify.desktop" ];
      "x-scheme-handler/discord" = [ "Discord.desktop" ];
      "inode/directory" = [ "nautilus.desktop" ];
      "application/pdf" = [ "zathura.desktop" ];
    };
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
      EDITOR = [ "helix" ];
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

  xdg = {    
    mime = {
      enable = true;
      addedAssociations = associations;
      defaultApplications = associations;
    };
  };
}
