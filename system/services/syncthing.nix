{
  pkgs,
  ...
}:
{
  services.syncthing = {
    enable = true;
    user = "breakerofhalos";
    group = "users";
    dataDir = "/home/breakerofhalos";
    configDir = "/home/breakerofhalos/.config/syncthing";
    guiAddress = "127.0.0.1:8384";

    openDefaultPorts = true;
  };
}
