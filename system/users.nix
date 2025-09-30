{ 
  lib,
  config,
  flake,
  pkgs, 
  ... 
}:
let
  ifTheyExist = config: groups: lib.filter (group: lib.hasAttr group config.users.groups) groups;
in
{
  users.users.breakerofhalos = {
    uid = 1000;
    isNormalUser = true;

    homix = true;

    home = "/home/breakerofhalos";

    shell = pkgs.fish;

    extraGroups =
      [
        "wheel"
        "nix"
      ]
      ++ ifTheyExist config [
        "network"
        "networkmanager"
        "systemd-journal"
        "audio"
        "pipewire"
        "video"
        "input"
        "plugdev"
        "lp"
        "power"
        "wireshark"
        "mysql"
        "docker"
        "podman"

        "git"
        "libvirtd"
        "cloudflared"
      ];
  };

  security = {
    sudo = {
      enable = true;
      extraRules = [
        {
          commands =
            builtins.map (command: {
              command = "/run/current-system/sw/bin/${command}";
              options = ["NOPASSWD"];
            })
            [ "poweroff" "reboot" "nixos-rebuild" "nix-env" "bandwhich" "systemctl" ];
          groups = [ "wheel" ];
        }
      ];
    };
  };
}
