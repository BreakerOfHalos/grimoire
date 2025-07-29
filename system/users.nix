{ config
, lib
, pkgs
, user
, sources
, ... }:
let
  ifTheyExist = config: groups: lib.filter (group: lib.hasAttr group config.users.groups) groups;
in
{
  users.users.breakerofhalos = {
    uid = 1000;
    isNormalUser = true;

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
