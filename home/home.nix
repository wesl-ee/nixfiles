{ config, lib, pkgs, ... }:
let
  sysconfig = (import <nixpkgs/nixos> {}).config;
in
{
  imports = [
    (./hosts + ("/" + sysconfig.networking.hostName + ".nix"))
  ];

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
      alias workspace-optimize="docker run --rm -v "$(pwd)":/code \
        --mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target \
        --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
        cosmwasm/workspace-optimizer:0.12.8"
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
    pkgs.slack

    pkgs.libnotify
    pkgs.scrot

    # Cryptoshit
    pkgs.monero-gui

    pkgs.tdesktop
    pkgs.inkscape
    pkgs.alacritty
    pkgs.brightnessctl
    pkgs.xdg-user-dirs
    pkgs.virt-manager
    pkgs.maxima

    # DJ shit
    pkgs.mixxx
    pkgs.nicotine-plus

    # Misc
    pkgs.xclip
    pkgs.jq

    # Language server
    pkgs.nodejs
    pkgs.nodePackages.typescript
    pkgs.sumneko-lua-language-server
    pkgs.rust-analyzer
    pkgs.ripgrep
    pkgs.rnix-lsp
    pkgs.ccls
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
    accounts.wesl-ee = {
      address = "w@wesl.ee";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp = {
        enable = true;
        tls.fingerprint = "EC:C3:E6:C5:61:C7:45:9D:59:06:50:52:4C:81:9B:90:66:63:24:C1:72:AB:FB:BD:E2:A4:D7:4F:AA:EB:DF:EA";
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
    vim.cmd("hi clear SignColumn")
    vim.api.nvim_set_hl(0, "Normal", { ctermbg=NONE, guibg=NONE })
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.signcolumn = "yes"
    vim.opt.termguicolors = true
    vim.opt.mouse = ""
    vim.opt.wrap = false
    vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
    vim.opt.tw = 80
    vim.opt.encoding = "utf-8"
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.tabstop = 4
    vim.opt.expandtab = true
    vim.g.mapleader = " "
    vim.opt.listchars = "tab:!·,trail:·"
    vim.cmd("hi NonText ctermfg=7 guifg=gray")
    vim.opt.list = true

    local opts = { noremap=true, silent=true }
    vim.keymap.set('n', '<Leader>w', ':write<CR>')
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

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

    require("sessions").setup({
      session_filepath = ".nvim/session",
    })
    require("workspaces").setup({
        hooks = {
            open = function()
              require("sessions").load(nil, { silent = true })
            end,
        }
    })
    require('lualine').setup({ options = {
      theme = 'papercolor_light',
      icons_enabled = false
    }})
    require('presence'):setup({
        auto_update = true,
        neovim_image_text = "Neovim",
        main_image = "file",
        buttons = true,
        show_time = true,
    })
    require("telescope").setup({})
    require("telescope").load_extension("workspaces")
    vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files)
    vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep)
    vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers)
    vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)
    vim.keymap.set('n', '<leader>fr', require('telescope.builtin').lsp_references)
    vim.keymap.set('n', '<leader>fw', ':Telescope workspaces<cr>')

    local lsp_status = require('lsp-status')
    lsp_status.register_progress()

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- LSP mappings
      local bufopts = { noremap=true, silent=true, buffer=bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', '<leader>m', vim.lsp.buf.formatting, bufopts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

      -- Status line
      lsp_status.on_attach(client)
    end

    local lsp = require "lspconfig"
    local cmp = require'cmp'
    local opts = {
      on_attach = on_attach,
    }

    local lspkind_comparator = function(conf)
      local lsp_types = require('cmp.types').lsp
      return function(entry1, entry2)
        if entry1.source.name ~= 'nvim_lsp' then
          if entry2.source.name == 'nvim_lsp' then
            return false
          else
            return nil
          end
        end
        local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
        local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
  
        local priority1 = conf.kind_priority[kind1] or 0
        local priority2 = conf.kind_priority[kind2] or 0
        if priority1 == priority2 then
          return nil
        end
        return priority2 < priority1
      end
    end

    local label_comparator = function(entry1, entry2)
      return entry1.completion_item.label < entry2.completion_item.label
    end

     cmp.setup({
      preselect = cmp.PreselectMode.None,
      -- enabled = function()
      --   -- disable completion if the cursor is `Comment` syntax group.
      --   return not cmp.config.context.in_syntax_group('Comment')
      -- end,
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
      },
      formatting = {
        format = function(entry, vim_item)
          local label = vim_item.abbr
          local truncated_label = vim.fn.strcharpart(label, 0, 30)
          if truncated_label ~= label then
            vim_item.abbr = truncated_label .. '…'
          end
          local kind = vim_item.kind
          local truncated_kind = vim.fn.strcharpart(kind, 0, 15)
          if truncated_kind ~= kind then
            vim_item.kind = truncated_kind .. '…'
          end
          local menu = vim_item.menu
          local truncated_menu = vim.fn.strcharpart(menu, 0, 15)
          if truncated_menu ~= menu then
            vim_item.menu = truncated_menu .. '…'
          end
          return vim_item
        end
      },
      window = {
        completion = {
          border = 'rounded',
          pumheight = 30,
        },
        documentation = {
          max_width = 40,
          max_height = 30,
          border = 'rounded',
        },
        formatting = {
          fields = {'menu', 'abbr', 'kind'}
        },
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item()),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item()),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
      }),
      sorting = {
        comparators = {
          lspkind_comparator({
            kind_priority = {
              Field = 11,
              Property = 11,
              Constant = 10,
              Enum = 10,
              EnumMember = 10,
              Event = 10,
              Function = 10,
              Method = 10,
              Operator = 10,
              Reference = 10,
              Struct = 10,
              Variable = 9,
              File = 8,
              Folder = 8,
              Class = 5,
              Color = 5,
              Module = 5,
              Keyword = 2,
              Constructor = 1,
              Interface = 1,
              Snippet = 0,
              Text = 1,
              TypeParameter = 1,
              Unit = 1,
              Value = 1,
            },
          }),
          label_comparator,
        },
      },
      sources = cmp.config.sources({
        {name = 'nvim_lsp', keyword_length = 3, max_item_count = 100,
          -- No snippets from LSP
          entry_filter = function(entry)
            return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
          end },
        {name = 'path' },
        {name = 'vsnip' },
      }, {
      })
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
      }, {
        { name = 'buffer' },
      })
    })

    -- LSP config
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    lsp.rust_analyzer.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.pyright.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.tsserver.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.rnix.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lsp.ccls.setup{
      capabilities = capabilities,
    }
    lsp.sumneko_lua.setup({
      capabilities = capabilities,
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
    })
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
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-git',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp',
        -- 'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip',
      }

      -- Workspaces
      use {
        'natecraddock/workspaces.nvim',
      }

      -- Sessions
      use {
        'natecraddock/sessions.nvim',
      }

      -- Discord rich presence
      use 'andweeb/presence.nvim'

      use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
      }

      use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
      }
    end)
  '';

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_KEY = "1068A429B387E62C";
      PASSWORD_STORE_DIR = "~/.password-store";
    };
  };

  services.password-store-sync = { };

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
  }; in
    {
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
          settings = pkgs.lib.recursiveUpdate common-settings { };
        };
        levana = {
          id = 1;
          bookmarks = { };
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
    delta.enable = true;
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
