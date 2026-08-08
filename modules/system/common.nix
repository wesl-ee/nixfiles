# Shared NixOS config for every host. Per-host config lives in ./hosts/<name>.nix.
{ config, pkgs, ... }:
{
  users.users.wesl-ee = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "dialout" "uucp" ];
  };

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

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.zsh.enable = true;
  programs.adb.enable = true;

  # xorg + Awesome WM
  services.xserver = {
    enable = true;
    displayManager.defaultSession = "none+awesome";
    windowManager.awesome.enable = true;
    libinput.enable = true;
  };

  time.timeZone = "US/Eastern";

  environment.systemPackages = with pkgs; [
    neovim
    acpi
    pavucontrol
    wget
    git
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
      noto-fonts-color-emoji
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
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
  services.printing.enable = true;

  # Nheko needs this
  services.passSecretService.enable = true;

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.download-buffer-size = 524288000; # 500 MiB
  nixpkgs.config.allowUnfree = true;
  # TODO: both marked insecure on nixos-25.11 as of this pin, pre-existing
  # issues surfaced only now because flakes actually eval this (channels
  # didn't). Revisit each:
  # - docker-28.5.2: unmaintained since 2025-11, upstream advises docker_29+
  # - olm-3.2.16: nheko's Matrix e2ee dep, deprecated upstream (CVE-2024-45191/2/3)
  nixpkgs.config.permittedInsecurePackages = [ "docker-28.5.2" "olm-3.2.16" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # Identical across every host today; any newly-installed host must override
  # this in its own hosts/<name>.nix rather than inherit it.
  system.stateVersion = "22.05";
}
