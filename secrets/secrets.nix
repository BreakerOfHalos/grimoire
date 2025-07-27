let
  users = {
    breakerofhalos = "";
  };

  hosts = {
    yawmga = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2g4va2+22UMzA9CTwpGmtj7GfpNOyeXZOMsitUgkSG";
      owner = "breakerofhalos";
    };
  };

  types = with hosts; {
    workstations = [
      yawmga
    ];
    servers = [
      
    ];
  };

  defAccess =
    list: urs:
    let
      filtered = builtins.filter (host: builtins.any (x: host.owner ==x) urs) list;
      key = builtins.map (host: host.key) filtered;
    in
    {
      publicKeys = keys ++ map (user: users.${user}) urs;
    };

  defAccessBreaker = list: defAccess list [ "breakerofhalos" ];
  defAccessAll = list: defAccess list (builtins.attrNames users);
in
{
  "pp-mFontUrl.age" = defAccessBreaker (types.workstations);
  "ppFontUrl.age" = defAccessBreaker (types.workstations);
  "pp-fFontUrl.age" = defAccessBreaker (types.workstations);
  "sysFontUrl.age" = defAccessBreaker (types.workstations);
}
