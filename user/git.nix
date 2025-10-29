{
  pkgs,
  lib,
  ...
}: 
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    config = {
      user = {
        email = "me@breakerofhalos.monster";
        name = "breakerofhalos";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQ53dGhZQR+Pe1Wy7kTk72V7RzcPsYoHKMI0AzYgx4y";
      };
      
      init = {
        defaultBranch = "main";
      };
      
      core = {
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        editor = "hx";
      };

      pull = {
        rebase = true;
        ff = "only";
      };

      rebase = {
        autoSquash = true;
        autoStash = true;
      };

      rerere = {
        autoupdate = true;
        enabled = true;
      };

      gpg.format = "ssh";
      gpg."ssh".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      commit.gpgsign = "true";

      branch.autosetupmerge = "true";
      push.default = "current";
      merge.stat = "true";
      repack.usedeltabaseoffset = "true";
    };
  };
}
