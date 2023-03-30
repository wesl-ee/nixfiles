{ config, pkgs, ... }: {
  imports = [
    ../../common/generic-qemu.nix
  ];

  networking.hostName = "xen-master";
  networking.firewall.enable = false;
}
