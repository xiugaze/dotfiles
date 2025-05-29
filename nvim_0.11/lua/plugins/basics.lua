return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
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
  { "lukas-reineke/virt-column.nvim", 
    opts = {
      enabled = true,
       virtcolumn = "+1,80"
    }
  },

}
