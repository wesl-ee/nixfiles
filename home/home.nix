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

  programs.firefox = {
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
	    isDefault = true;
	    id = 0;
        bookmarks = {
          "Home Manager Config Options" = {
            url = "https://rycee.gitlab.io/home-manager/options.html";
          };
	    };
	    settings = {
	      "browser.startup.homepage" = "https://wesl.ee/";
	    };
      };
      levana = {
        id = 1;
        isDefault = false;
        bookmarks = {
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
