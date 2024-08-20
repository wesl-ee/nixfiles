{ config, lib, pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.username = "wesl-ee";
  home.homeDirectory = "/Users/wesl-ee";

  home.sessionPath = [
    "$HOME/bin"
  ];

  programs.zsh = {
    enable = true;
    initExtra = ''
      export PS1='\n@\h \w >\[$(tput sgr0)\] '
      export PROMPT='%n@%m %2~ %(!.#.>) ' 
      export PROMPT_DIRTRIM=3
      export EDITOR=nvim
      export IPFS_PATH="$HOME/.ipfs"
      export PATH="$PATH:$HOME/go/bin"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  home.packages = [
    pkgs.neofetch
    pkgs.lynx
    pkgs.ipfs
    pkgs.kubectl

    # Language server
    pkgs.nodejs
    pkgs.nodePackages.typescript
    pkgs.nodePackages.typescript-language-server
    pkgs.lua-language-server
    pkgs.rust-analyzer
    # pkgs.nodePackages.pyright
    pkgs.ripgrep
    pkgs.nil
    pkgs.awscli2
    pkgs.aws-vault
    pkgs.ccls
    pkgs.gopls
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
      "divinity" = {
        hostname = "10.0.0.248";
        user = "wesl-ee";
        proxyJump = "xen";
      };
    };
  };


  # programs.mbsync.enable = true;
  # programs.msmtp.enable = true;
  # programs.notmuch = {
  #   enable = true;
  #   hooks = {
  #     preNew = "mbsync --all";
  #     postNew = ''
  #       # Tag new spam from presence of SpamAssassin X-Spam-Flag header
  #       notmuch tag +spam -inbox tag:inbox XSpamFlag:YES

  #       # Tag new drafts from other clients
  #       notmuch tag +draft -inbox -unread tag:inbox folder:/Drafts/

  #       # Tag new sent mail
  #       notmuch tag +sent -inbox -unread tag:inbox folder:/Sent/
  #     '';
  #   };
  #   new.tags = [
  #     "unread"
  #     "inbox"
  #   ];
  #   search.excludeTags = [
  #     "deleted"
  #     "spam"
  #   ];
  #   extraConfig = {
  #       # Index headers for easier searching
  #       index = {
  #           "header.XSpamFlag" = "X-Spam-Flag";
  #       };
  #   };
  # };
  # programs.neomutt = {
  #   enable = true;
  #   extraConfig = ''
  #     set quit
  #     unset mark_old
  #     set timeout=0
  #     unset markers

  #   bind attach <return>    view-mailcap

  #   set query_command="abook --mutt-query '%s'"
  #   macro index,pager a \
  #       "<pipe-message>abook --add-email-quiet<return>" \
  #       "Add this sender to abook"
  #   bind editor <Tab> complete-query

  #   set virtual_spoolfile
  #   virtual-mailboxes \
  #       "Inbox"     "notmuch://?query=tag:inbox not tag:archive"\
  #       "Void"     "notmuch://?query=not tag:inbox not tag:archive"\
  #       "Sent"      "notmuch://?query=tag:sent"\
  #       "Spam"      "notmuch://?query=tag:spam"\
  #       "Archived"     "notmuch://?query=tag:archive"

  #   set index_format="%4C %[%b %d %y] %zs %-15.15L (%?l?%4l&%4c?) %s"

  #   # notmuch bindings
  #   macro index \\\\ "<vfolder-from-query>"              # looks up a hand made query
  #   macro index A "<modify-labels>+archive -unread -inbox\n"        # tag as Archived
  #   macro index I "<modify-labels>-inbox -unread\n"                 # removed from inbox
  #   macro index S "<modify-labels-then-hide>-inbox -unread +spam\n" # tag as spam
  #   bind index,pager T modify-labels

  #   # Sidebar
  #   set sidebar_visible=no
  #   bind index <left> sidebar-prev          # got to previous folder in sidebar
  #   bind index <right> sidebar-next         # got to next folder in sidebar
  #   bind index <space> sidebar-open         # open selected folder from sidebar
  #   bind index,pager B sidebar-toggle-visible

  #   # Don't prompt for recipients on command line, let me edit manually
  #   set edit_headers
  #   set autoedit

  #   set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
  #   set mail_check_stats
  #   set sidebar_divider_char = '│'
  #   unset confirmappend      # don't ask, just do!
  #   set quit                 # don't ask, just do!!

  #   #------------------------------------------------------------
  #   # Vi Key Bindings
  #   #------------------------------------------------------------

  #   # Moving around
  #   bind attach,browser,index       g   noop
  #   bind attach,browser,index       gg  first-entry
  #   bind attach,browser,index       G   last-entry
  #   bind pager                      g  noop
  #   bind pager                      gg  top
  #   bind pager                      G   bottom
  #   bind pager                      k   previous-line
  #   bind pager                      j   next-line

  #   bind index,browser,pager                      r  noop
  #   bind index,browser,pager                      rr  reply
  #   bind index,browser,pager                      gr  group-reply

  #   # Scrolling
  #   bind attach,browser,pager,index \CF next-page
  #   bind attach,browser,pager,index \CB previous-page
  #   bind attach,browser,pager,index \Cu half-up
  #   bind attach,browser,pager,index \Cd half-down
  #   bind browser,pager              \Ce next-line
  #   bind browser,pager              \Cy previous-line
  #   bind index                      \Ce next-line
  #   bind index                      \Cy previous-line

  #   bind pager,index                d   noop
  #   bind pager,index                dd  delete-message

  #   # Threads
  #   bind browser,pager,index        N   search-opposite
  #   bind pager,index                dT  delete-thread
  #   bind pager,index                dt  delete-subthread
  #   bind pager,index                gt  next-thread
  #   bind pager,index                gT  previous-thread
  #   bind index                      za  collapse-thread
  #   bind index                      zA  collapse-all # Missing :folddisable/foldenable

  #   set mailcap_path = ~/.mailcaprc
  #   auto_view text/html
  #   '';
  # };
  # accounts.email = {
  #   maildirBasePath = "mail";
  #   accounts.wesl-ee = {
  #     address = "w@wesl.ee";
  #     mbsync = {
  #       enable = true;
  #       create = "maildir";
  #     };
  #     msmtp = {
  #       enable = true;
  #       tls.fingerprint = "1D:E7:94:6A:3A:A3:1E:54:A4:59:DF:51:E1:7F:70:1E:8A:FC:54:D0:3E:C2:63:95:5A:C4:F2:B6:FD:7D:D1:99";
  #       extraConfig = {
  #         port = "587";
  #         tls_starttls = "on";
  #       };
  #     };
  #     notmuch.enable = true;
  #     neomutt.enable = true;
  #     primary = true;
  #     passwordCommand = "pass email/w@wesl.ee";
  #     imap.host = "gyw.wesl.ee";
  #     smtp.host = "gyw.wesl.ee";
  #     realName = "Wesley Coakley";
  #     userName = "w@wesl.ee";
  #   };
  # };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_KEY = "1068A429B387E62C";
      PASSWORD_STORE_DIR = "/Users/wesl-ee/.password-store";
    };
  };

  home.file.".config/nvim/colors/paper.vim".source = builtins.fetchGit {
      url = "https://github.com/yorickpeterse/vim-paper.git";
      rev = "01b79707c2144f9c845057da2e7d6ec024e15c76";
    } + "/colors/paper.vim";

  home.file.".config/nvim/colors/tender.vim".source = builtins.fetchGit {
      url = "https://github.com/jacoborus/tender.vim";
      rev = "f361e9d907d2e5df703ee995f9032021ef674f2f";
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
  home.file.".config/nvim/lua".source = ../../nvim;
  # home.file.".config/nvim/lua/plugins.lua".text = builtins.readFile "../../nvim/plugins.lua";

  home.file.".config/alacritty/alacritty-theme".source = builtins.fetchGit {
    url = "https://github.com/alacritty/alacritty-theme.git";
    rev = "94e1dc0b9511969a426208fbba24bd7448493785";
  };
  home.file.".config/alacritty/alacritty.toml".text = ''
  import = ["~/.config/alacritty/alacritty-theme/themes/gruvbox_light.toml"]
  [font]
  size = 12

  [font.normal]
  family = "Hack"
  '';

  # home.file.".config/fontconfig/fonts.conf".text = ''
  #   <?xml version='1.0'?>
  #   <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
  #   <fontconfig>
  #     <alias>
  #       <family>xterm</family>
  #       <prefer>
  #         <family>Hack</family>
  #         <family>Noto Color Emoji</family>
  #         <family>Noto Sans CJK JP</family>
  #         <family>PowerlineSymbols</family>
  #         <family>Weather Icons</family>
  #       </prefer>
  #     </alias>
  #     <match>
  #       <test name="family"><string>Arial</string></test>
  #       <edit name="family" mode="assign" binding="strong">
  #         <string>Arimo</string>
  #       </edit>
  #     </match>
  #     <match>
  #       <test name="family"><string>Helvetica</string></test>
  #       <edit name="family" mode="assign" binding="strong">
  #         <string>Arimo</string>
  #       </edit>
  #     </match>
  #     <match>
  #       <test name="family"><string>Verdana</string></test>
  #       <edit name="family" mode="assign" binding="strong">
  #         <string>Arimo</string>
  #       </edit>
  #     </match>
  #     <match>
  #       <test name="family"><string>Tahoma</string></test>
  #       <edit name="family" mode="assign" binding="strong">
  #         <string>Arimo</string>
  #       </edit>
  #     </match>
  #     <match>
  #       <test name="family"><string>Comic Sans MS</string></test>
  #       <edit name="family" mode="assign" binding="strong">
  #         <string>Arimo</string>
  #       </edit>
  #     </match>
  #     <match>
  #       <test name="family"><string>Times New Roman</string></test>
  #       <edit name="family" mode="assign" binding="strong">
  #         <string>Noto Serif</string>
  #       </edit>
  #     </match>
  #     <match>
  #       <test name="family"><string>Times</string></test>
  #       <edit name="family" mode="assign" binding="strong">
  #         <string>Noto Serif</string>
  #       </edit>
  #     </match>
  #     <match>
  #       <test name="family"><string>Courier New</string></test>
  #       <edit name="family" mode="assign" binding="strong">
  #       <string>Mononoki</string>
  #       </edit>
  #     </match>
  #   </fontconfig>
  # '';

  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        source = builtins.fetchurl {
          url = "https://wesl.ee/pubkey.txt";
          sha256 = "102pwwv5pw6dqh9zf36fkr9viy44gsn1n5151mf76yk1dbcs2jsx";
        };
        trust = "ultimate";
      }
    ];
  };

  programs.git = {
    enable = true;
    userName = "Wesley Coakley";
    userEmail = "wesley@skip.money";
    ignores = [
      "*.swap"
      ".vim"
      ".nvim"
    ];
    signing = {
        key = "361FD33468D04DCE";
    };
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

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
