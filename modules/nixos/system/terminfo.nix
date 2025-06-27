# put terminfo onto our servers so the ssh experince is better
{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = lib.mkIf config.services.openssh.enable {
    grimoire.packages = {
      inherit (pkgs.ghostty) terminfo;
    };
  };
}
