{ config
, lib
, pkgs
, user
, sources
, grimoireLib
, ... }:
let
  grimoireLib = import ./lib { inherit lib; };
  user = "breakerofhalos";
in
{
  users.users.${user} = {
    uid = 1000;
    isNormalUser = true;
    hashedPassword = "$y$j9T$5gLgIR1EDwsvakM9v2WqB0$fteqAzttBy4yDECFCiLkYC15kGUTPAlhHsTXZXWVLxD";

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
