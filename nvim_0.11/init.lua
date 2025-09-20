vim.g.mapleader = ";"
vim.g.maplocalleader = ";"
vim.g.nixos = (string.find(vim.fn.system("lsb_release -a"), "NixOS") ~= nil)


require("config.options")
require("config.lazy")
require("config.lsp")
require("config.keys")


vim.diagnostic.config({
  virtual_text = { current_line = true }
})

local colorscheme = "melange"
local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not ok then
  vim.notify("coloscheme " .. colorscheme .. " not found")
end

vim.o.background = 'light'
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets"})
