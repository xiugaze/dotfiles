return {
  {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    keymaps = {
      ["<C-h>"] = {":TmuxNavigateLeft<cr>", mode = "n"},
      ["<C-j>"] = {":TmuxNavigateDown<cr>", mode = "n"},
      ["<C-k>"] = {":TmuxNavigateUp<cr>", mode = "n"},
      ["<C-l>"] = {":TmuxNavigateRight<cr>", mode = "n"},
      ["<C-\\>"] = {":TmuxNavigatePrevious<cr>", mode = "n"},
    },
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
    },
    win_options = {
      signcolumn = "yes:2"
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  },
  {
  "refractalize/oil-git-status.nvim",

    dependencies = {
      "stevearc/oil.nvim",
    },

    config = true,
  },
}
