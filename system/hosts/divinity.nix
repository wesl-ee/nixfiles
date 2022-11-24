{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.interfaces.enp11s0.ipv4.addresses = [ {
        address = "10.0.10.3";
        prefixLength = 24;
  } ];
  networking.interfaces.enp1s0.useDHCP = true;

  networking.hostName = "divinity";

  # HTC Vive Pro 2
  nixpkgs.overlays = [(self: super: {
    vivepro2-linux-driver = pkgs.fetchFromGitHub {
      owner = "CertainLach";
      repo = "VivePro2-Linux-Driver";
      rev = "02b25f136a5d3ad8d4fd4f4108592d285ebf49c5";
      sha256 = "";
    };
  })];

  fileSystems."/mnt/steam" =
    { device = "10.0.10.1:/srv/nfs/steam";
      fsType = "nfs";
      options = [
        "defaults"
        "timeo=900"
        "retrans=5"
        "_netdev"
      ];
    };
    fileSystems."/mnt/common" =
    { device = "10.0.10.1:/srv/nfs/common";
      fsType = "nfs";
      options = [
        "defaults"
        "timeo=900"
        "retrans=5"
        "_netdev"
      ];
    };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", GROUP="usb"
    # HTC Vive
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="usb"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", ATTRS{idProduct}=="2c87", GROUP="usb"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", ATTRS{idProduct}=="0306", GROUP="usb"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", ATTRS{idProduct}=="2134", GROUP="usb"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", ATTRS{idProduct}=="2744", GROUP="usb"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0424", ATTRS{idProduct}=="274d", GROUP="usb"
    # Valve dongle + lighthouses
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2101", GROUP="usb"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2000", GROUP="usb"
  '';

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+awesome";
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --auto --output HDMI-0 --rotate left --left-of DP-0
      '';
    };
    windowManager.awesome = {
      enable = true;
    };
    deviceSection = ''
      Option "UseEdidDpi" "FALSE"
    '';
    xrandrHeads = [
      "HDMI-0" {
        output = "HDMI-0";
        monitorConfig = ''
          DisplaySize 597 336
          Option "DPMS" "false"
        '';
      }
      "DP-0" {
        output = "DP-0";
        primary = true;
        monitorConfig = ''
          DisplaySize 597 336
          Option "DPMS" "false"
        '';
      }
    ];
  };
    environment.variables = {
    # GDK_SCALE = "2";
    # GDK_DPI_SCALE = "0.5";
    # _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
  hardware.video.hidpi.enable = true;
  services.xrdp = {
    enable = true;
    defaultWindowManager = "awesome";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

    # Enable sound.
  sound.enable = true;
      hardware.pulseaudio = {
        enable = true;
        daemon.config = {
          flat-volumes = "no";
          resample-method = "speex-float-10";
        };
        package = pkgs.pulseaudioFull;
      };
      hardware.bluetooth = {
        enable = true;
        package = pkgs.bluezFull;
      };
      nixpkgs.config.pulseaudio = true;

        services.xserver = {
    screenSection = ''
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
    '';
  };

  i18n.defaultLocale = "en_US.UTF-8";
  fileSystems."/mnt/img" = {
      device = "//10.0.0.28/img";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/etc/nixos/samba-img-secrets"];
  };

    nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.opengl.enable = true;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPatches = [
  #   { name = "drm-edid-non-desktop";
  #     patch = builtins.fetchurl
  #     "https://raw.githubusercontent.com/CertainLach/VivePro2-Linux-Driver/master/kernel-patches/0001-drm-edid-non-desktop.patch";
  #   }
  #   # { name = "drm-edid-type-7-timings";
  #   #   patch = builtins.fetchurl
  #   #   "https://raw.githubusercontent.com/CertainLach/VivePro2-Linux-Driver/master/kernel-patches/0002-drm-edid-type-7-timings.patch";
  #   # }
  #   { name = "drm-edid-dsc-bpp-parse";
  #     patch = builtins.fetchurl
  #     "https://raw.githubusercontent.com/CertainLach/VivePro2-Linux-Driver/master/kernel-patches/0003-drm-edid-dsc-bpp-parse.patch";
  #   }
  #   { name = "drm-amd-dsc-bpp-apply";
  #     patch = builtins.fetchurl
  #     "https://raw.githubusercontent.com/CertainLach/VivePro2-Linux-Driver/master/kernel-patches/0004-drm-amd-dsc-bpp-apply.patch";
  #   }
  # ];

  virtualisation.docker.enable = true;

  boot.initrd.availableKernelModules = [ "ahci" "virtio_pci" "xhci_pci" "sym53c8xx" "usbhid" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Steam stuff
  hardware.steam-hardware.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.driSupport32Bit = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5c3707c6-e159-47ab-ac3a-5638cefcf0db";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/52EE-C261";
      fsType = "vfat";
    };

  swapDevices = [ ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
