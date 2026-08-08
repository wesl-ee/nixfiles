# X11/awesome desktop tier: browsers, mail-adjacent GUI bits, media, fonts.
# Imported by every NixOS host except none currently opt out.
{ config, lib, pkgs, ... }:
{
  home.packages = [
    pkgs.neofetch
    pkgs.lynx
    pkgs.sxiv
    pkgs.kubo
    pkgs.zathura
    pkgs.rxvt-unicode

    # Chat
    pkgs.nheko

    pkgs.imagemagick
    pkgs.libnotify
    pkgs.scrot

    pkgs.alacritty
    pkgs.brightnessctl
    pkgs.xdg-user-dirs

    # Used in neomutt config to determine if I can open in FF
    pkgs.runningx
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      # Metamask
      {
        id = "nkbihfbeogaeaoehlefnkodbefgpgknn";
        version = "10.18.3";
      }
      # Keplr
      {
        id = "dmkamcknogkgcdfhhbddcghachkejeap";
        version = "0.10.22";
      }
      # Noscript
      {
        id = "doojmbjmlfjjnbmnoijecmcbfeoakpjm";
        version = "11.4.6";
      }
      # ublock
      {
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
        version = "1.44.0";
      }
      # Proxyswitch Omega
      {
        id = "padekgcemlokbadohgkifijomclgjgif";
        version = "2.5.21";
      }
      # No History
      {
        id = "ljamgkbcojbnmcaonjokopmcblmmpfch";
        version = "1.0.2";
      }
      # IPFS Companion
      {
        id = "nibjojkomfdiaoajekhjakgkdhaomnch";
        version = "2.19.1";
      }
      # xdefi
      {
        id = "hmeobnfnfcmdkdcmlblgagmfpfboieaf";
        version = "21.1.8";
      }
    ];
  };

  services.dunst = {
    enable = true;
    settings = { };
  };

  programs.rofi = {
    enable = true;
    font = "xft: Hack";
    pass.enable = true;
  };

  services.screen-locker = {
    enable = true;
    xautolock.enable = true;
    lockCmd = "\${pkgs.lightdm}/bin/dm-tool lock";
  };

  xsession.windowManager.awesome.noArgb = true;

  programs.mpv.enable = true;
  services.mpd = {
    enable = true;
    musicDirectory = "/mnt/public/Music";
  };
  programs.ncmpcpp.enable = true;

  home.file.".config/alacritty/alacritty-theme".source = builtins.fetchGit {
    url = "https://github.com/alacritty/alacritty-theme.git";
    rev = "03cce642656759f440c97bb99ce65fc1c5b064a1";
  };
  home.file.".config/alacritty/alacritty.toml".text = ''
[window]
opacity = 0.70

[font.normal]
family = "xterm"

[font]
size = 12

[general]
import = ["~/.config/alacritty/alacritty-theme/themes/tomorrow-night.toml"]

[colors.cursor]
cursor = '#FF9500'

[cursor]
blink_interval = 500

[cursor.style]
blinking = "On"
  '';

  home.file.".config/fontconfig/fonts.conf".text = ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>
      <alias>
        <family>xterm</family>
        <prefer>
          <family>Hack</family>
          <family>Noto Color Emoji</family>
          <family>Noto Sans CJK JP</family>
          <family>PowerlineSymbols</family>
          <family>Weather Icons</family>
        </prefer>
      </alias>
      <match>
        <test name="family"><string>Arial</string></test>
        <edit name="family" mode="assign" binding="strong">
          <string>Arimo</string>
        </edit>
      </match>
      <match>
        <test name="family"><string>Helvetica</string></test>
        <edit name="family" mode="assign" binding="strong">
          <string>Arimo</string>
        </edit>
      </match>
      <match>
        <test name="family"><string>Verdana</string></test>
        <edit name="family" mode="assign" binding="strong">
          <string>Arimo</string>
        </edit>
      </match>
      <match>
        <test name="family"><string>Tahoma</string></test>
        <edit name="family" mode="assign" binding="strong">
          <string>Arimo</string>
        </edit>
      </match>
      <match>
        <test name="family"><string>Comic Sans MS</string></test>
        <edit name="family" mode="assign" binding="strong">
          <string>Arimo</string>
        </edit>
      </match>
      <match>
        <test name="family"><string>Times New Roman</string></test>
        <edit name="family" mode="assign" binding="strong">
          <string>Noto Serif</string>
        </edit>
      </match>
      <match>
        <test name="family"><string>Times</string></test>
        <edit name="family" mode="assign" binding="strong">
          <string>Noto Serif</string>
        </edit>
      </match>
      <match>
        <test name="family"><string>Courier New</string></test>
        <edit name="family" mode="assign" binding="strong">
        <string>Mononoki</string>
        </edit>
      </match>
    </fontconfig>
  '';

  home.file.".mailcaprc".text = ''
    image/png; sxiv %s
    image/jpeg; sxiv %s
    application/pdf zathura %s pdf

    text/html; firefox %s &; test=test -n "$DISPLAY"; needsterminal;
    text/html; lynx -dump %s ; copiousoutput; nametemplate=%s.html
    text/*; less
  '';

  programs.firefox = let common-settings = {
    "browser.startup.homepage" = "https://wesl.ee/";
    "app.shield.optoutstudies.enabled" = false;
    "browser.contentblocking.category" = "standard";
    "browser.download.autohideButton" = false;
    "browser.formfill.enable" = false;
    "browser.newtabpage.enabled" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.feeds.topsites" = false;
    "browser.newtabpage.activity-stream.showSearch" = false;
    "browser.safebrowsing.malware.enabled" = false;
    "browser.safebrowsing.phishing.enabled" = false;
    "browser.search.region" = "US";
    "browser.search.suggest.enabled" = false;
    "browser.urlbar.suggest.history" = false;
    "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    "browser.urlbar.suggest.searches" = false;
    "browser.urlbar.suggest.topsites" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "dom.security.https_only_mode" = true;
    "dom.security.https_only_mode_ever_enabled" = true;
    "extensions.formautofill.addresses.enabled" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
    "extensions.ui.dictionary.hidden" = true;
    "extensions.ui.locale.hidden" = true;
    "extensions.ui.sitepermission.hidden" = true;
    "font.size.monospace.x-western" = 12;
    "font.size.variable.x-western" = 12;
    "gfx.webrender.enabled" = true;
    "layout.spellcheckDefault" = 0;
    "network.dns.disablePrefetch" = true;
    "network.predictor.enabled" = false;
    "network.prefetch-next" = false;
    "media.videocontrols.picture-in-picture.enabled" = false;
    "places.history.enabled" = false;
    "privacy.donottrackheader.enabled" = true;
    "privacy.history.custom" = true;
    "privacy.userContext.enabled" = true;
    "trailhead.firstrun.didSeeAboutWelcome" = true;
    "toolkit.telemetry.reportingpolicy.firstRun" = false;
    "toolkit.telemetry.pioneer-new-studies-available" = false;
    "signon.rememberSignons" = false;
    "services.sync.engine.history" = false;
  }; in
    {
      enable = true;
      profiles = {
        browse = {
          id = 0;
          bookmarks = {
            force = true;
            settings = [
              {
                name = "Home Manager Config Options";
                url = "https://rycee.gitlab.io/home-manager/options.html";
              }
              {
                name = "NixOS Packages";
                url = "https://search.nixos.org/";
                keyword = "@nixos";
              }
            ];
          };
          search = {
            force = true;
            default = "SearchGPT";
            engines = {
              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@npackages" ];
              };
              "NixOS Wiki" = {
                urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                definedAliases = [ "@nwiki" ];
              };
              "Startpage" = {
                urls = [{ template = "https://www.startpage.com/sp/search?query={searchTerms}"; } ];
                iconUpdateURL = "https://www.startpage.com/sp/cdn/favicons/favicon-96x96--default.png";
                definedAliases = [ "@sp" ];
              };
              "docs.rs" = {
                urls = [{ template = "https://docs.rs/releases/search?query={searchTerms}"; } ];
                iconUpdateURL = "https://docs.rs/favicon.ico";
                definedAliases = [ "@docsrs" ];
              };
              "Google Images" = {
                urls = [{ template = "https://www.google.com/search?tbm=isch&q={searchTerms}"; } ];
                iconUpdateURL = "https://www.google.com/favicon.ico";
                definedAliases = [ "@gimages" ];
              };
              "Danbooru" = {
                urls = [{ template = "https://danbooru.donmai.us/posts?tags={searchTerms}"; } ];
                iconUpdateURL = "https://danbooru.donmai.us/favicon.svg";
                definedAliases = [ "@danbooru" ];
              };
              "Gelbooru" = {
                urls = [{ template = "https://gelbooru.com/index.php?page=post&s=list&tags={searchTerms}"; } ];
                iconUpdateURL = "https://danbooru.donmai.us/favicon.svg";
                definedAliases = [ "@gelbooru" ];
              };
              "Twitter" = {
                urls = [{ template = "https://twitter.com/search?q={searchTerms}&f=live"; }];
                iconUpdateURL = "https://abs.twimg.com/favicons/twitter.2.ico";
                definedAliases = [ "@twitter" ];
              };
              "Github" = {
                urls = [{template = "https://github.com/search?q={searchTerms}"; }];
                iconUpdateURL = "https://github.githubassets.com/favicons/favicon.svg";
                definedAliases = [ "@gh" ];
              };
              "Etherscan" = {
                urls = [{ template = "https://etherscan.io/search?q={searchTerms}"; }];
                iconUpdateURL = "https://etherscan.io/images/favicon3.ico";
                definedAliases = [ "@etherscan" ];
              };
              "Tradingview" = {
                urls = [{ template = "https://www.tradingview.com/chart/?symbol={searchTerms}"; }];
                iconUpdateURL = "https://static.tradingview.com/static/images/favicon.ico";
                definedAliases = [ "@tv" ];
              };
              "SearchGPT" = {
                urls = [{ template = "https://chatgpt.com/?q={searchTerms}&temporary-chat=true&hints=search"; }];
                iconUpdateURL = "https://cdn.oaistatic.com/assets/favicon-180x180-od45eci6.webp";
                definedAliases = [ "@s" ];
              };
              "ChatGPT" = {
                urls = [{ template = "https://chatgpt.com/?q={searchTerms}&temporary-chat=true"; }];
                iconUpdateURL = "https://cdn.oaistatic.com/assets/favicon-180x180-od45eci6.webp";
                definedAliases = [ "@@" ];
              };
              "Google".metaData.alias = "@g";
              "Wikipedia".metaData.alias = "@wp";
            };
          };
          settings = pkgs.lib.recursiveUpdate common-settings { };
        };
      };
    };

  programs.delta.enableGitIntegration = true;

  xdg.userDirs = {
    enable = true;
    videos = "$HOME/vid";
    pictures = "$HOME/img";
    templates = "$HOME";
    publicShare = "$HOME";
    music = "/mnt/public/Music";
    download = "$HOME/dl";
    documents = "$HOME/doc";
    desktop = "$HOME";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
      # keyboard-us primary, mozc second; Ctrl+Space toggles between them
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "keyboard-us";
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "mozc";
      };
    };
  };
}
