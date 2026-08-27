# Shared home-manager config for every host, Linux and Darwin.
# Host-specific: home.username, home.homeDirectory, home.stateVersion,
# programs.git.userEmail / signing, extra zsh initExtra / sessionPath entries.
{ config, lib, pkgs, ... }:
{
  fonts.fontconfig.enable = true;

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
      export OPENAI_API_KEY=$(<~/.openai)
      export IPFS_PATH="$HOME/.ipfs"
      export PATH="$PATH:$HOME/go/bin"

      _sgpt_zsh() {
      if [[ -n "$BUFFER" ]]; then
          _sgpt_prev_cmd=$BUFFER
          BUFFER+="⌛"
          zle -I && zle redisplay
          BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd" --no-interaction)
          zle end-of-line
      fi
      }
      zle -N _sgpt_zsh
      bindkey ^o _sgpt_zsh

      sgpt_shell() {
          sgpt --shell "$*"
      }
      alias '?s'=sgpt_shell
      alias '?r'='sgpt --repl temp'
    '';
  };

  home.packages = [
    pkgs.ripgrep
    pkgs.jq
    pkgs.xclip

    # Language servers
    pkgs.nodejs
    pkgs.typescript
    pkgs.lua-language-server
    pkgs.rust-analyzer
    pkgs.gopls
    pkgs.ccls

    pkgs.shell-gpt
    pkgs.opencode
  ];

  home.activation.installClaudeCode =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      export NPM_CONFIG_PREFIX="$HOME/.npm-global"
      export PATH="$NPM_CONFIG_PREFIX/bin:${pkgs.nodejs}/bin:$PATH"
      ${pkgs.nodejs}/bin/npm ls -g @anthropic-ai/claude-code >/dev/null 2>&1 || \
        ${pkgs.nodejs}/bin/npm install -g @anthropic-ai/claude-code
    '';

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

  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        source = builtins.fetchurl {
          url = "https://wesl.ee/pubkey.txt";
          sha256 = "038fh65qgqai3x0g9mgrzcbh502jqqlbd45cckvb9nc4g9iv8b6d";
        };
        trust = "ultimate";
      }
    ];
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableExtraSocket = true;
    enableSshSupport = true;
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_KEY = "1068A429B387E62C";
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
    };
  };

  services.pass-secret-service.enable = true;

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

  home.file.".config/nvim/lua".source = ../../nvim;

  programs.git = {
    enable = true;
    userName = "Wesley Coakley";
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

  home.stateVersion = lib.mkDefault "22.05";

  programs.home-manager.enable = true;
}
