vim.g.mapleader = ';'
vim.g.maplocalleader = ';'
vim.g.sleuth_org_heuristics = 0

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  -- Git related plugins
  'tpope/vim-fugitive', -- git commands
  'tpope/vim-rhubarb',  -- git browse
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for L)SP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip'
    },
  }, -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',          opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▎" },
        topdelete = { text = "▎" },
        changedelete = { text = "▎" },
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  {
    'shaunsingh/nord.nvim',
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_italic = false
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = true
      vim.cmd.colorscheme 'nord'
    end,
  },
  'rafamadriz/friendly-snippets',
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'nord',
        component_separators = '|',
        section_separators = '',
        ignore_focus = {
          "dapui_watches", "dapui_breakpoints",
          "dapui_scopes", "dapui_console",
          "dapui_stacks", "dap-repl"
        }
      },
    },
  },
  'vimpostor/vim-tpipeline',
  {
    'nvim-orgmode/orgmode',
    config = function()
      require('orgmode').setup_ts_grammar()
      require("orgmode").setup({
        org_agenda_files = { "~/docs/org/**/*" },
        org_blank_before_new_entry = { false, false },
        win_split_mode = "float",
        org_hide_leading_stars = true,
        org_default_notes_file = "~/docs/org/**/*",
        org_deadline_warning_days = 7,
        org_agenda_start_on_weekday = false,
        org_log_repeat = nil,
        org_log_done = nil,
        org_highlight_latex_and_related = "native",
        highlight = {
          additional_vim_regex_highlighting = { 'org' },
        },
        mappings = {
          org = {
            org_next_visible_heading = "g}",
            org_previous_visible_heading = "g{",
          },
        },
        notifications = { enabled = true },
        org_agenda_templates = {
          m = {
            description = "Working on Ms5",
            template = "** Working on Ms5 %<%Y-%m-%d>\nSCHEDULED: %t\n:LOGBOOK:\nCLOCK: %U\n:END:",
            target = "~/sync/org/programming/ms5.org",
            headline = "MS5 Timesheet",
          },
          i = {
            description = "Thoughts",
            template = "** %?",
            target = "~/sync/org/life.org",
            headline = "Thoughts",
          },
          n = {
            description = "Random note",
            template = "* %?",
          },
          t = {
            description = "MS5 Task",
            target = "~/sync/org/programming/ms5.org",
            headline = "MS5 Refile",
            template = "** %?\nSCHEDULED: %t",
          },
        },
      })

      require("nvim-treesitter.configs").setup({
        -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
        highlight = {
          enable = true,
          disable = { "org" }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
          -- disable = function(lang, bufnr)
          -- 	return lang == "org"
          -- end,
          additional_vim_regex_highlighting = { "org" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
        },
        ensure_installed = { "org" },                    -- Or run :TSUpdate org
      })
    end
  },

  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      vim.opt.termguicolors = true;
      require('colorizer').setup()
    end
  },


  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',         opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("core.nvimtree").setup()
    end,
  },


  {
    'simrat39/rust-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap',
    },
  },
  --
  --
  {
    'saecki/crates.nvim',
    config = function()
      require('crates').setup()
    end,
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      {
        'mfussenegger/nvim-dap',
        config = function()
          require("core.dap")
        end,
      }
    }
  },


  { import = 'custom.plugins' },
}, {})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}


-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = 'lua',

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'org' },
  },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

require('orgmode').setup({
  org_agenda_files = '~/docs/org/*',
  org_default_notes_file = '~/docs/org/refile.org',
})

-- Diagnostic keymaps
vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev)
vim.keymap.set('n', 'g]', vim.diagnostic.goto_next)
vim.keymap.set('n', 'gk', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>sll', vim.diagnostic.setloclist)

require('lsp')
require('lsp.cmp')
require('core.rust-tools')

-- nvim-cmp setup

require("opts.keymaps").load();
require("opts.options").load();
