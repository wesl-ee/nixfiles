require('plugins')
vim.notify = require("notify")
vim.cmd("colorscheme paper")
vim.cmd("set nofixendofline")
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
-- Disable vim's native keyword completion
vim.keymap.set('i', '<C-p>', '<nop>', { noremap=true, silent=true })
vim.keymap.set('i', '<C-n>', require('cmp').mapping.complete(), { noremap=true, silent=true })
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
require("telescope").setup({})
require("telescope").load_extension("workspaces")
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').lsp_references)
vim.keymap.set('n', '<leader>fw', ':Telescope workspaces<cr>')
-- Local LLM mappings
vim.keymap.set({'n', 'v'}, '<leader>ld', ':LlmDelete<cr>')
vim.keymap.set({'n', 'v'}, '<leader>lj', ':LlmSelect<cr>')
vim.keymap.set({'n', 'v'}, '<leader>ll', ':Llm complete<cr>')
vim.keymap.set({'n', 'v'}, '<leader>lr', ':Llm rewrite<cr>')
vim.keymap.set({'n', 'v'}, '<leader>lc', ':LlmCancel<cr>')
vim.keymap.set({'n', 'v'}, '<leader>tj', ':Llm to-japanese<cr>')
vim.keymap.set({'n', 'v'}, '<leader>te', ':Llm to-english<cr>')
-- Gitsigns mappings
vim.keymap.set('n', '<leader>gb', ':Gitsigns blame_line<cr>')
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
  vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, bufopts)
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
  settings = {
    checkOnSave = {
      command = "clippy",
    },
    diagnostics = {
      enable = true,
      experimental = {
        enable = true,
      },
    },
  },
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
lsp.solc.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}
lsp.ccls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}
lsp.gopls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}
lsp.lua_ls.setup({
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
      telemetry = { enable = false },
    },
  },
})

local prompts = require('llm.prompts')
local openai = require('llm.providers.openai')
local llm = require('llm')

local function standard_code(input, context)
  local surrounding_text = prompts.limit_before_after(context, 30)

  local instruction = 'Replace the token <@@> with valid code. Respond only with code, never respond with an explanation, never respond with a markdown code block containing the code. Generate only code that is meant to replace the token, do not regenerate code in the context.'

  local fewshot = {
    {
      role = 'user',
      content = 'The code:\n```\nfunction greet(name) { console.log("Hello " <@@>) }\n```\n\nExisting text at <@@>:\n```+ nme```\n'
    },
    {
      role = 'assistant',
      content = '+ name'
    }
  }

  local content = 'The code:\n```\n' .. surrounding_text.before .. '<@@>' .. surrounding_text.after .. '\n```\n'

  if #input > 0 then
    content = content ..  '\n\nExisting text at <@@>:\n```' .. input .. '```\n'
  end

  if #context.args > 0 then
    content = content .. context.args
  end

  local messages = {
    {
      role = 'user',
      content = content
    }
  }

  return {
    instruction = instruction,
    fewshot = fewshot,
    messages = messages,
  }
end

require("llm").setup((function()
    model = 'Wizard-Vicuna-30B-Uncensored-GPTQ'

    return {
    default_prompt = 'complete',
    hl_group = 'Comment',
    prompts = {
      ['complete'] = vim.tbl_extend('force', openai.default_prompt, {
        options = {
          url = 'http://10.0.0.11:5001/v1/'
        },
        params = {
          max_tokens = 500,
          model,
        },
      }),
      ['rewrite'] = {
        provider = openai,
        options = {
          url = 'http://10.0.0.11:5001/v1/'
        },
        params = { model, },
        builder = function(input)
          return {
            messages = {
              {
                role = 'system',
                content = 'Rewrite the following text to improve readability and clarity',
              },
              {
                role = 'user',
                content = input,
              }
            }
          }
        end,
        mode = llm.mode.REPLACE
      },
      ['to-japanese'] = {
        provider = openai,
        options = { url = 'http://10.0.0.11:5001/v1/' },
        params = { model, },
        builder = function(input)
          return {
            messages = {
              {
                role = 'system',
                content = 'Translate the following text to Japanese',
              },
              {
                role = 'user',
                content = input,
              }
            }
          }
        end,
        mode = llm.mode.REPLACE
      },
      ['to-english'] = {
        provider = openai,
        options = {
          url = 'http://10.0.0.11:5001/v1/'
        },
        params = {
          model,
        },
        builder = function(input)
          return {
            messages = {
              {
                role = 'system',
                content = 'Translate the following text to English',
              },
              {
                role = 'user',
                content = input,
              }
            }
          }
        end,
        mode = llm.mode.REPLACE
      }
    },
} end)())


