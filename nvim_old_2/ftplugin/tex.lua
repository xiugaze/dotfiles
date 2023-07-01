local opts = { noremap = true, silent = true }
-- Shorten function name
vim.api.nvim_set_keymap("n", "<leader>l", ":VimtexCompile<cr>", opts)
