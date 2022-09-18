# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/nvme0n1p2";
    };
  };

  networking.hostName = "air2earth";
  networking.wireless.enable = true;

  location.provider = "geoclue2";
  hardware.bluetooth.enable = true;
  services.redshift = {
    enable = true;
    brightness = {
      day = "1";
      night = "1";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  services.avahi = {
  nssmdns = true;
  enable = true;
  ipv4 = true;
  ipv6 = true;
  publish = {
    enable = true;
    addresses = true;
    workstation = true;
  };
  };

  services.xserver = {
    enable = true;
    displayManager.defaultSession = "none+awesome";

    windowManager.awesome = {
      enable = true;
    };

    libinput.enable = true;
    wacom.enable = true;

    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "TearFree" "true"
    '';
    dpi = 148;
  };
  services.ipfs.enable = true;

  time.timeZone = "US/Eastern";

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.wesl-ee = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
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

  environment.systemPackages = with pkgs; [
    neovim
    acpi
    wget
    links2
    nmap
    awesome
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.dconf.enable = true;

  # Enable the OpenSSH daemon.
  services.acpid.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      hack-font
      mononoki
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      fira-code-symbols
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif"
          "Noto Serif CJK JP"
          "Fira Code Symbol"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Arimo"
          "Noto Sans CJK JP"
          "Fira Code Symbol"
          "Noto Color Emoji"
        ];
        monospace = [
          "Hack"
          "Noto Sans CJK JP"
          "Fira Code Symbol"
          "Noto Color Emoji"
        ];
      };
    };
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  # Personal wiki
  services.nginx = {
    enable = true;
    virtualHosts."local.wesl.ee" = {
      root = "/www/local.wesl.ee";
    };
  };

  networking.extraHosts =
  ''
    # Personal wiki (local build)
    127.0.0.1 local.wesl.ee
  '';


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

