local M = {}

local options = {

  --clipboard = "c,
  -- foldmethod = "expr",
  backup = false,
  breakindent = true,
  cmdheight = 1,
  conceallevel = 1,
  cursorline = false,
  expandtab = false,
  fileencoding = "utf-8",
  -- foldexpr = "nvim_treesitter#foldexpr()",
  foldmethod = "manual",
  hidden = true,
  hlsearch = true,
  ignorecase = true,
  mouse = "a",
  number = true,
  numberwidth = 2,
  pumheight = 12,
  relativenumber = true,
  scrolloff = 8,
  showtabline = 2,
  sidescrolloff = 8,
  signcolumn = "yes",
  splitbelow = true,
  splitright = true,
  swapfile = false,
  termguicolors = true,
  timeoutlen = 300,
  undofile = true,
  updatetime = 100,
  writebackup = false,
  laststatus = 0,
}


-- vim.filetype.add {
--   extension = {
--     tex = "tex",
--   }
-- }

M.load = function()
  for k, v in pairs(options) do
    vim.opt[k] = v
  end
  vim.opt.shortmess:append "c" -- don't show redundant messages from ins-completion-menu
  vim.opt.shortmess:append "I" -- don't show the default intro message
  vim.opt.whichwrap:append "<,>,[,],h,l" -- hl goes to newline at end
end


return M
