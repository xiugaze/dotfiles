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
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    }
  },
  {
    "HiPhish/rainbow-delimiters.nvim"
  },
  -- {
  --   'MeanderingProgrammer/render-markdown.nvim',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, 
  --   ---@module 'render-markdown'
  --   ---@type render.md.UserConfig
  --   opts = {},
  -- },
  {
    "danymat/neogen",
    config = true,
  },
  { 
    "shortcuts/no-neck-pain.nvim",
    opts = { width = 120 },
  },
  {
    "tpope/vim-sleuth",
  },
  {
    'seblyng/nvim-tabline',
        dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Optional
        opts = {
        },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
  },
    {
        "linrongbin16/gitlinker.nvim",
        cmd = "GitLink",
        opts = {
          router = {
            browse = {
              ["stash"] = "https://stash/projects/"
                .. "{_A.ORG}/repos/"
                .. "{_A.REPO}/browse/"
                -- .. "{_A.FILE}?at="
                .. "{_A.FILE}#"
                -- .. "{_A.REV}#"
                .. "{_A.LSTART}"
                .. "{(_A.LEND > _A.LSTART and ('-' .. _A.LEND) or '')}",
            },
          },

        },
        keys = {
          { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
          { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
        },
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
