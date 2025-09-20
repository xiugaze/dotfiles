return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*]],
        keyword = "bg",
      }
    }
  },
  {
    "HiPhish/rainbow-delimiters.nvim"
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, 
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "danymat/neogen",
    config = true,
  },
  {
    "tpope/vim-sleuth",
  },
  {
    'seblyng/nvim-tabline',
        dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Optional
        opts = { },
  },
{
      "reybits/scratch.nvim",
      lazy = true,
      keys = {
          { "<leader>ts", "<cmd>ScratchToggle<cr>", desc = "Toggle Scratch Buffer" },
      },
      cmd = {
          "ScratchToggle",
      },
      opts = {},
  }
  -- {'romgrk/barbar.nvim',
  --   dependencies = {
  --     'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
  --     'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  --   },
  --   init = function() vim.g.barbar_auto_setup = false end,
  --   opts = {
  --     highlight_visible = false,
  --   },
  --   version = '^1.0.0', -- optional: only update when a new 1.x version is released
  -- },
}
