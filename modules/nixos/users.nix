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

    home = "/home/${user}";

    shell = pkgs.fish;

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

    packages = builtins.attrValues {
      inherit (pkgs)
        starship
        zoxide
        eza
        yazi
        fzf
        btop
        hyfetch
        helix
        anyrun
        obsidian
        flameshot
        obs-studio
        morgen
        orca-slicer
        discordo
        moonlight
        # nheko # currently insecure
        junction
        quickshell
        ghostty
        fuzzel
        vivaldi
        nix-your-shell
        nil
        nixpkgs-fmt
        ;
    };
  };
}
