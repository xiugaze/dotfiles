vim.g.mapleader = ";"
vim.g.maplocalleader = ";"
vim.g.nixos = (string.find(vim.fn.system("lsb_release -a"), "NixOS") ~= nil)

require("config.options")
require("config.lazy")
-- require("config.lsp")
require("config.keys")

vim.diagnostic.config({
  virtual_text = { current_line = true }
})


