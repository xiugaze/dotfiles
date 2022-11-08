-- no recursive maps, silent is not seeing an output for the keymap. maybe we want this?
local opts = { noremap = true, silent = true }

-- terminal options, no output
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- leader key
keymap("", ";", "<Nop>", opts)
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",


-- copy-paste from system clipboard
keymap("", "<leader>y", "\"+y", opts)
keymap("", "<leader>p", "\"+p", opts)

-- jump to end of line
keymap("", "H", "^", opts)
keymap("", "L", "$", opts)

-- end of word
keymap("n", "E", "ge", opts)

-- capitalize selection
keymap("n", "K", "~h", opts)
keymap("v", "K", "~", opts)
keymap("x", "K", "~", opts)

-- navigate tabs with leader l and h
keymap("", "<leader>l", ":tabn<CR>", opts)
keymap("", "<leader>h", ":tabp<CR>", opts)

-- Better window navigation
-- NOTE: should get removed with tmux nav plugin
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)


-- resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Telescope
-- keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>f", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>g", "<cmd>Telescope live_grep<cr>", opts)

-- Nvimtree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)
