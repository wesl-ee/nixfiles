{ config, pkgs, lib, ... }:

{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "wonder-pop"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable the X11 windowing system.
  services.xserver = {
    wacom.enable = true;

    modules = [ pkgs.xf86_input_wacom ];
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "TearFree" "true"
      Option "AccelMethod" "sna"
    '';
  };

  fileSystems."/mnt/my-cloud" = {
      device = "10.0.10.2:/personal";
      fsType = "nfs";
      options = [ "noauto" "x-systemd.idle-timeout=60" "x-systemd.mount-timeout=5s" ];
  };

  fileSystems."/mnt/public" = {
      device = "10.0.10.2:/public";
      fsType = "nfs";
      options = [ "noauto" "x-systemd.idle-timeout=60" "x-systemd.mount-timeout=5s" ];
  };

  fileSystems."/mnt/steam" = {
      device = "10.0.10.2:/steam";
      fsType = "nfs";
      options = [ "noauto" "x-systemd.idle-timeout=60" "x-systemd.mount-timeout=5s" ];
  };

  users.users.wesl-ee = {
    extraGroups = [ "wheel" "video" "dialout" "uucp" "libvirtd" ];
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services.tlp = {
    enable = true;
    extraConfig = ''
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
      ENERGY_PERF_POLICY_ON_BAT=powersave
    '';
  };

  virtualisation.libvirtd.enable = true;

  services.acpid.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "ahci" "firewire_ohci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/234d9fdf-d917-4e52-9614-5eb390c75a67";
      fsType = "ext4";
    };

  swapDevices = [ ];

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.0.20.105/24" ];
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard-keys/wonder-pop-xen";
      peers = [
      {
        publicKey = "5xodOxP3JGfj9bqysb+/lg0UUSK7ig27flLlT5+1dRI=";
        allowedIPs = [ "10.0.20.1/32" "10.0.10.0/24" ];
        endpoint = "xen.wesl.ee:51871";
      } ];
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s25.useDHCP = lib.mkDefault true;
  # networking.interfaces.wls3.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  networking.enableIntel3945ABGFirmware = true;
}

