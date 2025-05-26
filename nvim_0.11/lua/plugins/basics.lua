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

}
