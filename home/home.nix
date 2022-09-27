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

    # Language server
    pkgs.nodejs
    pkgs.nodePackages.typescript
    pkgs.sumneko-lua-language-server
    pkgs.rust-analyzer
    pkgs.rnix-lsp
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

      set sidebar_visible
      set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
      set mail_check_stats
      set sidebar_divider_char = '│'
unset confirmappend      # don't ask, just do!
set quit                 # don't ask, just do!!

# sidebar mappings
bind index,pager \Ck sidebar-prev
bind index,pager \Cj sidebar-next
bind index,pager \Co sidebar-open
bind index,pager \Cp sidebar-prev-new
bind index,pager \Cn sidebar-next-new
bind index,pager B sidebar-toggle-visible

      set mailcap_path = ~/.mailcaprc
      auto_view text/html
    '';
  };
  accounts.email = {
    maildirBasePath = "mail";
    accounts.levana = {
      address = "wesley@levana.finance";
      flavor = "gmail.com";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      neomutt.enable = true;
      passwordCommand = "pass crypto/levana/google-app-password";
      imap.host = "imap.gmail.com";
      smtp.host = "smtp.gmail.com";
      realName = "Wesley Coakley";
      userName = "wesley.coakley@levana.finance";
    };
    accounts.wesl-ee = {
      address = "w@wesl.ee";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp = {
        enable = true;
        extraConfig = {
          port = "587";
          tls_starttls = "on";
        };
      };
      notmuch.enable = true;
      neomutt.enable = true;
      primary = true;
      passwordCommand = "pass email/w@wesl.ee";
      imap.host = "wesl.ee";
      smtp.host = "wesl.ee";
      realName = "Wesley Coakley";
      userName = "w@wesl.ee";
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ mozc hangul ];
  };

  home.file.".config/nvim/colors/paper.vim".source = builtins.fetchGit {
    url = "https://gitlab.com/yorickpeterse/vim-paper.git";
    ref = "master";
  } + "/colors/paper.vim";

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = [ pkgs.vimPlugins.packer-nvim ];
    extraConfig = ''
      lua require('config')
    '';
  };

  home.file.".config/nvim/lua/config.lua".text = ''
    require('plugins')

    vim.cmd("colorscheme paper")
    vim.cmd("let g:coq_settings = { 'auto_start': 'shut-up', 'display.pum.fast_close': v:false, 'display.icons.mode': 'none' }")
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.signcolumn = "yes"
    vim.opt.termguicolors = true
    vim.opt.mouse = ""
    vim.opt.wrap = false
    vim.opt.tw = 80
    vim.opt.encoding = "utf-8"
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.tabstop = 4
    vim.opt.expandtab = true
    vim.opt.listchars = "tab:!·,trail:·"

    vim.api.nvim_set_hl(0, "Normal", { ctermbg=NONE, guibg=NONE })

    local opts = { noremap=true, silent=true }
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

    -- Plugin setup
    require('gitsigns').setup({
      signs = {
        add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
        change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete       = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete    = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      },
    })
    require('session_manager').setup({})

    local lsp_status = require('lsp-status')
    lsp_status.register_progress()

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- LSP mappings
      local bufopts = { noremap=true, silent=true, buffer=bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, bufopts)
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
      vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
      vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

      -- Status line
      lsp_status.on_attach(client)
    end

    local lsp = require "lspconfig"
    local coq = require "coq"
    local opts = {
      on_attach = on_attach,
    }

    -- LSP config
    lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities({
      on_attach = on_attach,
    }))
    lsp.pyright.setup(coq.lsp_ensure_capabilities({
      on_attach = on_attach,
    }))
    lsp.tsserver.setup(coq.lsp_ensure_capabilities({
      on_attach = on_attach,
    }))
    lsp.rnix.setup(coq.lsp_ensure_capabilities({
      on_attach = on_attach,
    }))
    lsp.sumneko_lua.setup(coq.lsp_ensure_capabilities({
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    }))

  '';

  home.file.".config/nvim/lua/plugins.lua".text = ''
    local use = require('packer').use

    return require('packer').startup(function(use)
      -- Configurations for Nvim LSP
      use 'neovim/nvim-lspconfig' 

      -- Status bar
      use 'nvim-lua/lsp-status.nvim'

      -- Gitsigns
      use {
        'lewis6991/gitsigns.nvim'
      }

      -- Completion
      use {
        'ms-jpq/coq_nvim', branch = 'coq'
      }

      -- Session manager
      use {
        'Shatur/neovim-session-manager',
        requires = {{'nvim-lua/plenary.nvim', opt = true}}
      }

      use {
        'nvim-lua/plenary.nvim'
      }

      use {
        'ms-jpq/coq.artifacts', branch = 'artifacts'
      }

      -- Discord rich presence
      use 'andweeb/presence.nvim'
    end)
  '';

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_KEY="1068A429B387E62C";
      PASSWORD_STORE_DIR="~/.password-store";
    };
  };

  services.password-store-sync = {
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
    userEmail = "w@wesl.ee";
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
    font = "xft: Hack";
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
