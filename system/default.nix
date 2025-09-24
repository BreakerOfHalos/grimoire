{ ... }:
{
  imports = [
    ./boot
    #./gaming
    ./hardware
    ./networking
    #./security
    ./services
    ./core.nix
    ./fonts.nix
    ./nix.nix
    ./nixpkgs.nix
    ./systemd.nix
    ./users.nix
    ./wayland.nix
    ./xdg.nix
  ];

}
