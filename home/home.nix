{ config, lib, pkgs, ... }:
let
  sysconfig = (import <nixpkgs/nixos> {}).config;
in
{
  imports = [
    (./hosts + ("/" + sysconfig.networking.hostName + ".nix"))
  ];

  home.username = "wesl-ee";
  home.homeDirectory = "/home/wesl-ee";

  fonts.fontconfig.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export PS1='\u@\h \w >\[$(tput sgr0)\] '
      export PROMPT_DIRTRIM=3
      export EDITOR=nvim
      export IPFS_PATH="$HOME/.ipfs"
    '';
  };

  home.packages = [
    pkgs.neofetch
    pkgs.lynx
    pkgs.sxiv
    pkgs.ipfs
    pkgs.zathura

    # Chat
    pkgs.discord
    pkgs.discord-rpc
    pkgs.slack

    pkgs.libnotify
    pkgs.scrot

    # Cryptoshit
    pkgs.monero-gui

    pkgs.alacritty
    pkgs.brightnessctl
    pkgs.xdg-user-dirs
    pkgs.virt-manager

    # Misc
    pkgs.xclip

    pkgs.jq
    pkgs.pywal

    # coc
    pkgs.nodejs

    # coc-lua
    pkgs.sumneko-lua-language-server
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
        version = "10.18.0";
      }
      # Keplr
      {
        id = "dmkamcknogkgcdfhhbddcghachkejeap";
        version = "0.10.16";
      }
      # Noscript
      {
        id = "doojmbjmlfjjnbmnoijecmcbfeoakpjm";
        version = "11.4.6";
      }
      # ublock
      {
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
        version = "1.43.0";
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

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };
  programs.neomutt = {
    enable = true;
    extraConfig = ''
      set quit
      unset mark_old
      set timeout=0

      set mailcap_path = ~/.mailcaprc
      auto_view text/html
    '';
  };
  accounts.email = {
    accounts.w = {
      address = "w@wesleycoakley.com";
      imap.host = "hooya.org";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      neomutt.enable = true;
      primary = true;
      passwordCommand = "pass email/w@wesleycoakley.com";
      smtp.host = "hooya.org";
      realName = "Wesley Coakley";
      userName = "w@wesleycoakley.com";
    };
  };

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
        "rpc.enabled" = false;
        "rpc.detailsEditing" = "{workspace_folder}";
        "rpc.detailsViewing" = "In {workspace_folder}";
        "rpc.showProblems" = false;
        "suggest.noselect" = true;
        "suggest.enablePreview" = true;
        "suggest.enablePreselect" = false;
        "suggest.disableKind" = true;
        languageserver = {
          lua = {
            command = "lua-language-server";
            filetypes = [ "lua" ];
          };
          rust = {
            command = "rust-analyzer";
            filetypes = [ "rust" ];
            root_pattern = [ "Cargo.toml" "rust-project.json" ];
          };
          ccls = {
            command = "ccls";
            filetypes = [ "c" "cpp" "objc" "objcpp" ];
            root_pattern = [ ".ccls" "compile_commands.json" ".git" ];
            initialization_options = {
              cache = { directory = "/tmp/ccls"; };
            };
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
      set tabstop=4
      set encoding=utf-8
      set shiftwidth=4
      set softtabstop=4
      set expandtab
      set termguicolors
      match ExtraWhitespace /\s\+\%#\@<!$/
      set listchars=tab:!·,trail:·
    '';
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_KEY="1068A429B387E62C";
      PASSWORD_STORE_DIR="~/.password-store";
    };
  };

  services.password-store-sync = {
  };

  home.file.".config/alacritty/alacritty.yml".text = ''
font:
  normal:
    family: xterm
  size: 12
schemes:
  Metrostyle: &Metrostyle
  # Default colors   
    primary:     
      background: '#fffdef'     
      foreground: '#000000' 

    normal:
      black:   '#000000'
      red:     '#d41243'
      green:   '#8ec127'
      yellow:  '#f47835'
      blue:    '#0040db'
      magenta: '#a200ff'
      cyan:    '#00aedb'
      white:   '#DDDDDD'
   
    # Bright colors
    bright:
      black:   '#888888'
      red:     '#d41243'
      green:   '#8ec127'
      yellow:  '#f47835'
      blue:    '#0040db'
      magenta: '#a200ff'
      cyan:    '#00aedb'
      white:   '#FFFFFF'
  Atom2Light: &Atom2Light
    primary:
      background: '0xf8f8f8'
      foreground: '0x2a2b33'

    normal:
      black:   '0x000000'
      red:     '0xde3d35'
      green:   '0x3e953a'
      yellow:  '0xd2b67b'
      blue:    '0x2f5af3'
      magenta: '0xa00095'
      cyan:    '0x3e953a'
      white:   '0xbbbbbb'

    bright:
      black:   '0x000000'
      red:     '0xde3d35'
      green:   '0x3e953a'
      yellow:  '0xd2b67b'
      blue:    '0x2f5af3'
      magenta: '0xa00095'
      cyan:    '0x3e953a'
      white:   '0xffffff'
  Breeze2: &Breeze2
    primary:
      background: '#232627'
      foreground: '#fcfcfc'

      dim_foreground:     '#eff0f1'
      bright_foreground:  '#fcfcfc'
      dim_background:     '#31363b'
      bright_background:  '#000000'

    normal:
      black:      '#232627'
      red:        '#ed1515'
      green:      '#11d116'
      yellow:     '#f67400'
      blue:       '#1d99f3'
      magenta:    '#9b59b6'
      cyan:       '#00ced1'
      white:      '#63686d'

    bright:
      black:      '#7f8c8d'
      red:        '#ff4040'
      green:      '#19c68a'
      yellow:     '#fdbc4b'
      blue:       '#3daee9'
      magenta:    '#8e44ad'
      cyan:       '#00ced1'
      white:      '#808080'

    dim:
      black:      '#31363b'
      red:        '#783228'
      green:      '#17a262'
      yellow:     '#b65619'
      blue:       '#1b668f'
      magenta:    '#614a73'
      cyan:       '#00ffff'
      white:      '#63686d'
  '';

  home.file.".config/fontconfig/fonts.conf".text = ''
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
  <alias>
    <family>xterm</family>
    <prefer>
      <family>ProFont</family>
      <family>Noto Color Emoji</family>
      <family>Noto Sans CJK JP</family>
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

    text/html; lynx -dump %s ; copiousoutput; nametemplate=%s.html
    text/*; less
  '';
  home.file.".config/discord/settings.json".text = ''
    {
      "MINIMIZE_TO_TRAY": false,
      "OPEN_ON_STARTUP": false,
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

  xdg.userDirs = {
    enable = true;
    videos = "$HOME/vid";
    pictures = "$HOME/img";
    templates = "$HOME";
    publicShare = "$HOME";
    music = "$HOME/music";
    download = "$HOME/dl";
    documents = "$HOME/doc";
    desktop = "$HOME";
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
