{
  lib,
  ...
}:
{
  security.tpm2 = {
    # enable Trusted Platform Module 2 support
    enable = lib.mkDefault true;

    # enable Trusted Platform 2 userspace resource manager daemon
    abrmd.enable = lib.mkDefault false;

    # set TCTI environment variables to the specified values if enabled
    # - TPM2TOOLS_TCTI
    # - TPM2_PKCS11_TCTI
    tctiEnvironment.enable = lib.mkDefault true;

    # enable TPM2 PKCS#11 tool and shared library in system path
    pkcs11.enable = lib.mkDefault true;
  };

  boot.initrd.kernelModules = [ "tpm" ];
}