{ config, pkgs, ... }:
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

  home.packages = [
    pkgs.neofetch
    pkgs.sxiv

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

  programs.chromium = {
    enable = true;
    extensions = [ ];
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

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    # coc = {
    #   enable = true;
    # };
    plugins = with pkgs.vimPlugins; [
      vim-nix
    ];
    extraConfig = ''
      set number
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
      "xft:Terminus (TTF):pixelsize=18"
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

  xresources.extraConfig = builtins.readFile(
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "xresources";
      rev = "a9cd582faeef2f7410eb7d4b5a83d026e3f2b865";
      sha256 = "xyqXjlB6gAJiId6VrD9bWXbHQBOXlkcacfMCbeg43bk=";
    } + "/mocha.Xresources"
  );

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
