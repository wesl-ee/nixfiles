{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;
  services.openssh.forwardX11 = true;
  networking.interfaces.enp1s0.useDHCP = true;
  # networking.interfaces.enp15s3u3u2c2.useDHCP = false;

  networking.hostName = "divinity";

  environment.systemPackages = with pkgs; let
  	# ollamagpu = pkgs.ollama.override { llama-cpp = (pkgs.llama-cpp.override {cudaSupport = true; openblasSupport = false; }); };
  in
  [
    # cudatoolkit
    # python312
    # python312Packages.pip
    # python312Packages.torchvision
    # python312Packages.torchWithCuda
    # python312Packages.pybind11
     libGL libGLU
    ntfs3g
    linuxPackages.nvidia_x11
    glib zlib stdenv.cc
    qemu
    # ollamagpu
    wireguard-tools
  ];

  networking.extraHosts = ''
    10.0.0.21 plex.xen.wesl.ee
  '';

  # HTC Vive Pro 2
  # nixpkgs.overlays = [(self: super: {
  #   vivepro2-linux-driver = pkgs.fetchFromGitHub {
  #     owner = "CertainLach";
  #     repo = "VivePro2-Linux-Driver";
  #     rev = "02b25f136a5d3ad8d4fd4f4108592d285ebf49c5";
  #     sha256 = "";
  #   };
  # })];

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
    # Bigscreen Beyond
    SUBSYSTEM=="usb", ATTRS{idVendor}=="35db", ATTRS{idProduct}=="0101", GROUP="usb"

    # DDCutil
    KERNEL=="i2c-[0-9]*", TAG+="uaccess"
  '';

  virtualisation.libvirtd = {
  enable = true;
  qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = true;
    swtpm.enable = true;
  };
};

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    wacom.enable = true;
    dpi = 109;
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+awesome";
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --pos 1440x1120 --auto --output DP-2 --auto --rotate left --left-of HDMI-0
        ${pkgs.xorg.xset}/bin/xset -dpms
        ${pkgs.xorg.xset}/bin/xset s off
      '';
    };
    windowManager.awesome = {
      enable = true;
    };
    serverFlagsSection = ''
      Option "BlankTime"  "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
    '';
    deviceSection = ''
      Option "UseEdidDpi" "FALSE"
    '';
    xrandrHeads = [
      "DP-2" {
        output = "DP-2";
        monitorConfig = ''
          Option "DPMS" "false"
        '';
      }
      "HDMI-0" {
        output = "HDMI-0";
        primary = true;
        monitorConfig = ''
          Option "DPMS" "false"
        '';
      }
    ];
  };

  services.xrdp = {
    enable = true;
    defaultWindowManager = "awesome";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

programs.nix-ld.enable = true;

    hardware.nvidia.open = true;
    # Enable sound.
      #hardware.pulseaudio = {
      #  enable = true;
      #  daemon.config = {
      #    flat-volumes = "no";
      #    resample-method = "speex-float-10";
      #  };
      #  package = pkgs.pulseaudioFull;
      #};
      hardware.bluetooth = {
        enable = true;
        package = pkgs.bluez;
      };
      #nixpkgs.config.pulseaudio = true;

        services.xserver = {
    screenSection = ''
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
    '';
  };

  i18n.defaultLocale = "en_US.UTF-8";
  fileSystems."/mnt/my-cloud" = {
      device = "10.0.30.1:/personal";
      fsType = "nfs";
      options = [ "noauto" "x-systemd.idle-timeout=60" "x-systemd.mount-timeout=5s" "uid=wesl-ee" ];
  };

  fileSystems."/mnt/public" = {
      device = "10.0.30.1:/public";
      fsType = "nfs";
      options = [ "noauto" "x-systemd.idle-timeout=60" "x-systemd.mount-timeout=5s" "uid=wesl-ee" ];
  };

  fileSystems."/mnt/steam" = {
      device = "10.0.30.1:/steam";
      fsType = "nfs";
      options = [ "noauto" "x-systemd.idle-timeout=60" "x-systemd.mount-timeout=5s" ];
  };

  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.opengl.enable = true;
  # boot.kernelPatches = [
  #   { name = "drm-edid-non-desktop-beyond";
  #     patch = ./beyondKernel.patch;
  #   }
  # ];

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
  boot.kernelModules = [ "kvm-intel" "i2c_dev" ];
  boot.extraModulePackages = [ ];

  # Steam stuff
  hardware.steam-hardware.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.driSupport32Bit = true;

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices = [ ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  users.users.wesl-ee.extraGroups = [ "docker" "disk" "adbusers" "libvirtd" ];
}
