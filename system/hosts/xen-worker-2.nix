{ config, pkgs, ... }: {
  imports = [
    ../../common/generic-qemu.nix
  ];

  networking.hostName = "xen-worker-2";
  networking.firewall.enable = false;
}
