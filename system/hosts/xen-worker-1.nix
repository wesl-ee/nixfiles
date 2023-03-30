{ config, pkgs, ... }: {
  imports = [
    ../../common/generic-qemu.nix
  ];

  networking.hostName = "xen-worker-1";
  networking.firewall.enable = false;
}
