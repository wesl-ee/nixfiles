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
    'hrsh7th/cmp-nvim-lua',
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
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  -- use {
  --   'j-hui/fidget.nvim'
  -- }
  use {
    'gsuuon/model.nvim',
    requires = { 'rcarriga/nvim-notify' }
  }
end)
