return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter", -- right after done loading
  branch = '0.1.x',
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make", -- runs on install
      cond = function()
        return vim.fn.executable("make") == 1
      end
    },
    "nvim-telescope/telescope-ui-select.nvim",
    "albenisolmos/telescope-oil.nvim",
    { "nvim-tree/nvim-web-devicons" },
    'nullromo/telescope-box-drawing.nvim',
  },

  config = function()
    require("telescope").setup({
      extensions = {
        ['ui-select'] = {
          require("telescope.themes").get_dropdown(),
        },

        ["file_browser"] = {
          hijack_netrw = true,
        },
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        },
        oil = {
            hidden = true,
            debug = false,
            no_ignore = false,
            show_preview = true,
        },
      }
    })
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'file_browser')

    -- temporary hacky fix, get rid of this 
    -- when https://github.com/nvim-telescope/telescope.nvim/issues/3436
    -- gets merged
    vim.api.nvim_create_autocmd("User", {
      pattern = "TelescopeFindPre",
      callback = function()
        vim.opt_local.winborder = "none"
        vim.api.nvim_create_autocmd("WinLeave", {
          once = true,
          callback = function()
            vim.opt_local.winborder = "single"
          end,
        })
      end,
    })
  end
  -- NOTE: telescope keymaps are loaded with other keymaps
}
