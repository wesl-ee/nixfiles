{ config, lib, pkgs, ... }:
let
  sysconfig = (import <nixpkgs/nixos> {}).config;
in
{
  fonts.fontconfig.enable = true;

  home.username = "wesl-ee";
  home.homeDirectory = "/home/wesl-ee";

  home.sessionPath = [
    "$HOME/bin"
  ];

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export PS1='\u@\h \w >\[$(tput sgr0)\] '
      export PROMPT_DIRTRIM=3
      export EDITOR=nvim
      export IPFS_PATH="$HOME/.ipfs"
      export PATH="$PATH:$HOME/go/bin"
    '';
  };

  home.packages = [
    pkgs.neofetch
    pkgs.lynx
    pkgs.sxiv
    pkgs.ipfs
    pkgs.zathura
    pkgs.rxvt-unicode

    # Chat
    pkgs.nheko

    pkgs.imagemagick
    pkgs.libnotify
    pkgs.scrot

    # Cryptoshit
    pkgs.monero-gui

    pkgs.inkscape
    pkgs.deluge
    pkgs.alacritty
    pkgs.brightnessctl
    pkgs.xdg-user-dirs
    pkgs.virt-manager
    pkgs.maxima

    # Multimedia
    pkgs.gimp

    # DJ shit
    pkgs.mixxx
    pkgs.nicotine-plus

    # Misc
    pkgs.xclip
    pkgs.jq

    pkgs.kubectl

    # Used in neomutt config to determine if I can open in FF
    pkgs.runningx

    # Language server
    pkgs.nodejs
    pkgs.nodePackages.typescript
    pkgs.lua-language-server
    pkgs.rust-analyzer
    pkgs.nodePackages.pyright
    pkgs.ripgrep
    pkgs.rnix-lsp
    pkgs.ccls
    pkgs.gopls
    # pkgs.lua54Packages.lua-lsp
  ];



  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "gyw" = {
        hostname = "gyw.wesl.ee";
        user = "w";
      };
      "eon-break" = {
        hostname = "eon-break.wesl.ee";
        user = "wesl-ee";
      };
      "xen" = {
        hostname = "xen.wesl.ee";
        user = "w";
      };
    };
  };

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

  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        source = builtins.fetchurl {
          url = "https://wesl.ee/pubkey.txt";
          # hash = "sha256-18kpj4mm0z9cg67imclnq3xsx792zwsnacp61z7xdgxpy7y7qjhi";
        };
        trust = "ultimate";
      }
    ];
  };

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
      postNew = ''
        # Tag new spam from presence of SpamAssassin X-Spam-Flag header
        notmuch tag +spam -inbox tag:inbox XSpamFlag:YES

        # Tag new drafts from other clients
        notmuch tag +draft -inbox -unread tag:inbox folder:/Drafts/

        # Tag new sent mail
        notmuch tag +sent -inbox -unread tag:inbox folder:/Sent/
      '';
    };
    new.tags = [
      "unread"
      "inbox"
    ];
    search.excludeTags = [
      "deleted"
      "spam"
    ];
    extraConfig = {
        # Index headers for easier searching
        index = {
            "header.XSpamFlag" = "X-Spam-Flag";
        };
    };
  };
  programs.neomutt = {
    enable = true;
    extraConfig = ''
      set quit
      unset mark_old
      set timeout=0
      unset markers

    bind attach <return>    view-mailcap

    set query_command="abook --mutt-query '%s'"
    macro index,pager a \
        "<pipe-message>abook --add-email-quiet<return>" \
        "Add this sender to abook"
    bind editor <Tab> complete-query

    set virtual_spoolfile
    virtual-mailboxes \
        "Inbox"     "notmuch://?query=tag:inbox not tag:archive"\
        "Void"     "notmuch://?query=not tag:inbox not tag:archive"\
        "Sent"      "notmuch://?query=tag:sent"\
        "Spam"      "notmuch://?query=tag:spam"\
        "Archived"     "notmuch://?query=tag:archive"

    set index_format="%4C %[%b %d %y] %zs %-15.15L (%?l?%4l&%4c?) %s"

    # notmuch bindings
    macro index \\\\ "<vfolder-from-query>"              # looks up a hand made query
    macro index A "<modify-labels>+archive -unread -inbox\n"        # tag as Archived
    macro index I "<modify-labels>-inbox -unread\n"                 # removed from inbox
    macro index S "<modify-labels-then-hide>-inbox -unread +spam\n" # tag as spam
    bind index,pager T modify-labels

    # Sidebar
    set sidebar_visible=no
    bind index <left> sidebar-prev          # got to previous folder in sidebar
    bind index <right> sidebar-next         # got to next folder in sidebar
    bind index <space> sidebar-open         # open selected folder from sidebar
    bind index,pager B sidebar-toggle-visible

    # Don't prompt for recipients on command line, let me edit manually
    set edit_headers
    set autoedit

    set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
    set mail_check_stats
    set sidebar_divider_char = '│'
    unset confirmappend      # don't ask, just do!
    set quit                 # don't ask, just do!!

    #------------------------------------------------------------
    # Vi Key Bindings
    #------------------------------------------------------------

    # Moving around
    bind attach,browser,index       g   noop
    bind attach,browser,index       gg  first-entry
    bind attach,browser,index       G   last-entry
    bind pager                      g  noop
    bind pager                      gg  top
    bind pager                      G   bottom
    bind pager                      k   previous-line
    bind pager                      j   next-line

    bind index,browser,pager                      r  noop
    bind index,browser,pager                      rr  reply
    bind index,browser,pager                      gr  group-reply

    # Scrolling
    bind attach,browser,pager,index \CF next-page
    bind attach,browser,pager,index \CB previous-page
    bind attach,browser,pager,index \Cu half-up
    bind attach,browser,pager,index \Cd half-down
    bind browser,pager              \Ce next-line
    bind browser,pager              \Cy previous-line
    bind index                      \Ce next-line
    bind index                      \Cy previous-line

    bind pager,index                d   noop
    bind pager,index                dd  delete-message

    # Threads
    bind browser,pager,index        N   search-opposite
    bind pager,index                dT  delete-thread
    bind pager,index                dt  delete-subthread
    bind pager,index                gt  next-thread
    bind pager,index                gT  previous-thread
    bind index                      za  collapse-thread
    bind index                      zA  collapse-all # Missing :folddisable/foldenable

    set mailcap_path = ~/.mailcaprc
    auto_view text/html
    '';
  };
  accounts.email = {
    maildirBasePath = "mail";
    accounts.wesl-ee = {
      address = "w@wesl.ee";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp = {
        enable = true;
        tls.fingerprint = "1D:E7:94:6A:3A:A3:1E:54:A4:59:DF:51:E1:7F:70:1E:8A:FC:54:D0:3E:C2:63:95:5A:C4:F2:B6:FD:7D:D1:99";
        extraConfig = {
          port = "587";
          tls_starttls = "on";
        };
      };
      notmuch.enable = true;
      neomutt.enable = true;
      primary = true;
      passwordCommand = "pass email/w@wesl.ee";
      imap.host = "gyw.wesl.ee";
      smtp.host = "gyw.wesl.ee";
      realName = "Wesley Coakley";
      userName = "w@wesl.ee";
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
    ];
  };

  home.file.".config/nvim/colors/paper.vim".source = builtins.fetchGit {
      url = "https://gitlab.com/yorickpeterse/vim-paper.git";
      ref = "master";
    } + "/colors/paper.vim";

  home.file.".config/nvim/colors/tender.vim".source = builtins.fetchGit {
      url = "https://github.com/jacoborus/tender.vim";
      ref = "master";
  } + "/colors/tender.vim";

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = [ pkgs.vimPlugins.packer-nvim ];
    extraConfig = ''
      lua require('config')
    '';
  };

  # Neovim
  home.file.".config/nvim/lua/config.lua".text = builtins.readFile "/home/wesl-ee/nixfiles/nvim/config.lua";
  home.file.".config/nvim/lua/plugins.lua".text = builtins.readFile "/home/wesl-ee/nixfiles/nvim/plugins.lua";

  programs.mpv = {
    enable = true;
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_KEY = "1068A429B387E62C";
      PASSWORD_STORE_DIR = "/home/wesl-ee/.password-store";
    };
  };

  services.password-store-sync = { };
  services.pass-secret-service.enable = true;
  services.mpd = {
    enable = true;
    musicDirectory = "/mnt/public/Music";
  };
  programs.ncmpcpp = {
    enable = true;
  };

  home.file.".config/alacritty/alacritty-theme".source = builtins.fetchGit {
    url = "https://github.com/eendroroy/alacritty-theme.git";
    ref = "master";
  };
  home.file.".config/alacritty/alacritty.yml".text = ''
    font:
      normal:
        family: xterm
      size: 9
    import:
      - ~/.config/alacritty/alacritty-theme/themes/gruvbox_light.yaml
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
            "Home Manager Config Options" = {
              url = "https://rycee.gitlab.io/home-manager/options.html";
            };
            "NixOS Packages" = {
              url = "https://search.nixos.org/";
              keyword = "@nixos";
            };
          };
          search = {
            force = true;
            default = "Startpage";
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
              "Google".metaData.alias = "@g";
              "Wikipedia".metaData.alias = "@wp";
            };
          };
          settings = pkgs.lib.recursiveUpdate common-settings { };
        };
      };
    };

  programs.git = {
    enable = true;
    userName = "Wesley Coakley";
    userEmail = "w@wesl.ee";
    ignores = [
      "*.swap"
      ".vim"
      ".nvim"
    ];
    delta = {
      enable = true;
      options = {
        light = true;
      };
    };
    lfs.enable = true;
    extraConfig = {
      init = {
        core = {
          whitespace = "trailing-space,space-before-tab";
        };
        defaultBranch = "trunk";
      };
    };
  };

  programs.rofi = {
    enable = true;
    font = "xft: Hack";
    pass.enable = true;
  };

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

  services.screen-locker = {
    enable = true;
    xautolock.enable = true;
    lockCmd = "\${pkgs.lightdm}/bin/dm-tool lock";
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableExtraSocket = true;
    enableSshSupport = true;
  };

  xsession.windowManager.awesome.noArgb = true;

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
}
