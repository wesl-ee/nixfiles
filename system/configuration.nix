# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports = [
    # System-specific configuration (ie per-host)
    /etc/nixos/host.nix
    # System users
    /etc/nixos/users.nix
  ];

  # Redshift for automatic temperature adjustment
  location.provider = "geoclue2";
  virtualisation.docker.enable = true;
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

  # xorg + Awesome WM
  services.xserver = {
    enable = true;
    displayManager.defaultSession = "none+awesome";
    windowManager.awesome.enable = true;
    libinput.enable = true;
  };

  time.timeZone = "US/Eastern";

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    acpi
    pavucontrol
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

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      hack-font
      google-fonts
      mononoki
      weather-icons
      powerline-symbols
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

  # Chromecast discoverability
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

  # Nheko needs this
  services.passSecretService.enable = true;

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

