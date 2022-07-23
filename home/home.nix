{ config, lib, pkgs, ... }:
{
  home.username = "wesl-ee";
  home.homeDirectory = "/home/wesl-ee";

  fonts.fontconfig.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export PS1='\u@\h \w >\[$(tput sgr0)\] '
      export PROMPT_DIRTRIM=3
      export EDITOR=nvim
    '';
  };

  home.shellAliases = {
    firefox = "firefox -profilemanager";
  };

  home.packages = [
    pkgs.neofetch
    pkgs.sxiv
    pkgs.ipfs

    # Chat
    pkgs.discord
    pkgs.slack

    pkgs.libnotify
    pkgs.scrot

    pkgs.pywal

    # coc
    pkgs.nodejs

    # coc-lua
    pkgs.sumneko-lua-language-server

    pkgs.terminus_font_ttf
    pkgs.dejavu_fonts
    pkgs.source-serif-pro
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk
    pkgs.noto-fonts-emoji
    pkgs.fira-code
    pkgs.dina-font
    pkgs.fira-code
    pkgs.fira-code-symbols
  ];

  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "gyw" = {
        hostname = "gyw.wesl.ee";
        user = "w";
      };
    };
  };

  programs.irssi = {
    enable = true;
    networks = {
      libera = {
        nick = "wesl-ee";
        server = {
          address = "irc.libera.chat";
          port = 6697;
          autoConnect = true;
        };
        channels = {
          ncsulug.autoJoin = true;
        };
      };
    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      # Metamask
      {
        id = "nkbihfbeogaeaoehlefnkodbefgpgknn";
        version = "10.17.0";
      }
      # Keplr
      {
        id = "dmkamcknogkgcdfhhbddcghachkejeap";
        version = "0.10.13";
      }
      # Noscript
      {
        id = "doojmbjmlfjjnbmnoijecmcbfeoakpjm";
        version = "11.4.6";
      }
      # ublock
      {
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
        version = "";
      }
    ];
  };

  services.dunst = {
    enable = true;
    settings = {
    };
  };

  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        source = builtins.fetchurl "https://wesl.ee/pubkey.txt";
        trust = "ultimate";
      }
    ];
  };

  # accounts.email = {
  #   "w@wesleycoakley.com" = {
  #   };
  #   "wesley@levana.finance" = {
  #   };
  # };

  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ mozc hangul ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    coc = {
      enable = true;
      settings = {
        "suggest.noselect" = true;
        "suggest.enablePreview" = true;
        "suggest.enablePreselect" = false;
        "suggest.disableKind" = true;
        languageserver = {
          lua = {
            command = "lua-language-server";
            filetypes = [ "lua" ];
          };
        };
      };
    };
    plugins = with pkgs.vimPlugins; [
      vim-nix
      coc-lua
    ];
    extraConfig = ''
      set number
      colorscheme default
      set mouse=
      set termguicolors
      set tabstop=4
      set encoding=utf-8
      set shiftwidth=4
      set softtabstop=4
      set expandtab
      highlight ExtraWhitespace ctermbg=red guibg=red
      match ExtraWhitespace /\s\+\%#\@<!$/
    '';
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_KEY="1068A429B387E62C";
    };
  };

  services.password-store-sync = {
  };

  home.file.".config/discord/settings.json".text = ''
    {
      "SKIP_HOST_UPDATE": true
    }
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
      "layout.spellcheckDefault" = 0;
      "network.dns.disablePrefetch" = true;
      "network.predictor.enabled" = false;
      "network.prefetch-next" = false;
      "places.history.enabled" = false;
      "privacy.donottrackheader.enabled" = true;
      "privacy.history.custom" = true;
      "privacy.userContext.enabled" = true;
      "trailhead.firstrun.didSeeAboutWelcome" = true;
      "toolkit.telemetry.reportingpolicy.firstRun" = false;
      "toolkit.telemetry.pioneer-new-studies-available" = false;
      "signon.rememberSignons" = false;
      "services.sync.engine.history" = false;
    }; in {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      noscript
      startpage-private-search
      ublock-origin
      cookie-autodelete
      ipfs-companion
      user-agent-string-switcher
    ];
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
        settings = pkgs.lib.recursiveUpdate common-settings {
        };
      };
      levana = {
        id = 1;
        bookmarks = {
	    };
        settings = pkgs.lib.recursiveUpdate common-settings {
        };
      };
    };
  };

  programs.urxvt = {
    enable = true;
    fonts = [
      "8x13"
      "xft:Noto Sans CJK:style=Regular:pixelsize=18"
      "xft:Noto Color Emoji:style=Regular:pixelsize=18"
    ];
    scroll.bar = {
      floating = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "Wesley Coakley";
    userEmail = "w@wesleycoakley.com";
    ignores = [
      "*.swap"
      ".vim"
    ];
    delta.enable = true;
    lfs.enable = true;
    signing.key = "361FD33468D04DCE";
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
    font = "xft: Terminus (TTF):pixelsize=20";
    pass.enable = true;
  };

  xresources.extraConfig = ''
    ! special
    *.foreground:   #ffffff
    *.background:   #000000
    *.cursorColor:  #ffffff

    ! black
    *.color0:       #282a2e
    *.color8:       #ffffff

    ! red
    *.color1:       #ff3535
    *.color9:       #2845ff

    ! green
    *.color2:       #fff967
    *.color10:      #1248ff

    ! yellow
    *.color3:       #ffa465
    *.color11:      #ffffff

    ! blue
    *.color4:       #008cff
    *.color12:      #ffffff

    ! magenta
    *.color5:       #bf00ff
    *.color13:      #ffffff

    ! cyan
    *.color6:       #00ffde
    *.color14:      #ffffff

    ! white
    *.color7:       #636363
    *.color15:      #ffffff
  '';
#  xresources.extraConfig = builtins.readFile(
#    pkgs.fetchFromGitHub {
#      owner = "catppuccin";
#      repo = "xresources";
#      rev = "a9cd582faeef2f7410eb7d4b5a83d026e3f2b865";
#      sha256 = "xyqXjlB6gAJiId6VrD9bWXbHQBOXlkcacfMCbeg43bk=";
#    } + "/mocha.Xresources"
#  );

  xdg.userDirs = {
    enable = true;
    videos = "$HOME/vid";
    templates = "$HOME";
    publicShare = "$HOME";
    music = "$HOME/music";
    download = "$HOME/dl";
    documents = "$HOME/dl";
    desktop = "$HOME";
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  xsession.windowManager.awesome.noArgb = true;

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
}
