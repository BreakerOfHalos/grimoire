{
  pkgs,
  ...
}:
{
  hardware.gpgSmartcards.enable = true;

  services = {
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  programs = {
    ssh.startAgent = false;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # Yubico's official tools
  environment.systemPackages = [
    pkgs.yubikey-manager # cli
  ]; 
}