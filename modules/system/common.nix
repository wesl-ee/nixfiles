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
    android-tools
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.dconf.enable = true;

  environment.etc."chromium/policies/managed/history.json".text = builtins.toJSON {
    SavingBrowserHistoryDisabled = true;
    NewTabPageLocation = "about:blank";
    SearchSuggestEnabled = false;
  };

  environment.etc."chromium/policies/managed/search.json".text = builtins.toJSON {
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Google AI Mode";
    DefaultSearchProviderKeyword = "ai";
    DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}&udm=50";
  };

  environment.etc."chromium/policies/managed/site-search.json".text = builtins.toJSON {
    SiteSearchSettings = [
      { name = "Nix Packages"; shortcut = "np"; url = "https://search.nixos.org/packages?type=packages&query={searchTerms}"; }
      { name = "NixOS Wiki"; shortcut = "nw"; url = "https://nixos.wiki/index.php?search={searchTerms}"; }
      { name = "Startpage"; shortcut = "sp"; url = "https://www.startpage.com/sp/search?query={searchTerms}"; }
      { name = "docs.rs"; shortcut = "dr"; url = "https://docs.rs/releases/search?query={searchTerms}"; }
      { name = "Google Images"; shortcut = "gi"; url = "https://www.google.com/search?tbm=isch&q={searchTerms}"; }
      { name = "Danbooru"; shortcut = "db"; url = "https://danbooru.donmai.us/posts?tags={searchTerms}"; }
      { name = "Gelbooru"; shortcut = "gb"; url = "https://gelbooru.com/index.php?page=post&s=list&tags={searchTerms}"; }
      { name = "Twitter"; shortcut = "tw"; url = "https://twitter.com/search?q={searchTerms}&f=live"; }
      { name = "Github"; shortcut = "gh"; url = "https://github.com/search?q={searchTerms}"; }
      { name = "Etherscan"; shortcut = "es"; url = "https://etherscan.io/search?q={searchTerms}"; }
      { name = "Tradingview"; shortcut = "tv"; url = "https://www.tradingview.com/chart/?symbol={searchTerms}"; }
      { name = "SearchGPT"; shortcut = "s"; url = "https://chatgpt.com/?q={searchTerms}&temporary-chat=true&hints=search"; }
      { name = "ChatGPT"; shortcut = "c"; url = "https://chatgpt.com/?q={searchTerms}&temporary-chat=true"; }
      { name = "Google"; shortcut = "g"; url = "https://www.google.com/search?q={searchTerms}"; }
      { name = "Wikipedia"; shortcut = "wp"; url = "https://en.wikipedia.org/w/index.php?search={searchTerms}"; }
    ];
  };

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
