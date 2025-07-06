{ config
, lib
, pkgs
, user
, sources
, grimoireLib
, ... }:
{
  users.users.breakerofhalos = {
    uid = 1000;
    isNormalUser = true;

    home = "/home/${user}";

    shell = pkgs.fish;

    maid = ../maid;

    extraGroups =
      [
        "wheel"
        "nix"
      ]
      ++ grimoireLib.ifTheyExist config [
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
}
