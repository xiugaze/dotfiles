local M = {}

local opts_any = { noremap = true, silent = true }

local opts = {
  any = opts_any,
  insert_mode = opts_any,
  normal_mode = opts_any,
  visual_mode = opts_any,
  visual_block_mode = opts_any,
  command_mode = opts_any,
  operator_pending_mode = opts_any,
  term_mode = { silent = true },
}

local mode_adapters = {
  insert_mode = "i",
  normal_mode = "n",
  term_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
  operator_pending_mode = "o",
  any = "",
}

local maps = {
  any = {
    ["<leader>y"] = "\"+y",
    ["<leader>p"] = "\"+p",
    ["<leader>tl"] = ":tabn<CR>",
    ["<leader>th"] = ":tabp<CR>",
    ["H"] = "^",
    ["L"] = "$",
  },
  normal_mode = {
    -- replaced by tmux nav
    -- ["<C-h>"] = "<C-w>h",
    -- ["<C-j>"] = "<C-w>j",
    -- ["<C-k>"] = "<C-w>k",
    -- ["<C-l>"] = "<C-w>l",
    -- end of last word
    ["E"] = "ge",
    ["<C-_>"] = "gcc",
    -- back and forth
  },
  insert_mode = {
    ["<C-BS>"] = "<C-W>",
    ["<C-H>"] = "<C-W>",
  },
  visual_mode = {
    -- stay in indent
    ["<"] = "<gv",
    [">"] = ">gv",
    ["E"] = "ge",
    -- back and forth
    ["H"] = "^",
    ["L"] = "$",
  },
}

function M.set_keymaps(mode, key, val)
  local opt = opts[mode] or opts_any
  if type(val) == "table" then
    opt = val[2]
    val = val[1]
  end
  -- if val is defined (not nil)
  if val then
    vim.keymap.set(mode, key, val, opt)
  else
    pcall(vim.api.nvim_del_keymap, mode, key)
  end
end

function M.load_mode(mode, keymaps)
  -- mode = translate the mode string to a char
  mode = mode_adapters[mode] or mode
  -- for (input, output) in each table of mappings
  for k, v in pairs(keymaps) do
    M.set_keymaps(mode, k, v)
  end
end

function M.load()
  -- mode is the key i.e. "normal_mode"
  -- mapping is a table of k,v pairs for each mode
  for mode, mapping in pairs(maps) do
    M.load_mode(mode, mapping)
  end
  vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- telescope
  local map = vim.keymap.set
  local ts = require('telescope.builtin')
  map("n", "<leader>ff", ts.find_files, { desc = "[F]ind [F]iles" })
  map("n", "<leader>fs", ts.grep_string, { desc = "[F]ind [S]tring" })
  map("n", "<leader>fh", ts.help_tags, { desc = "[F]ind [H]elp tags" })
  map("n", "<leader>fg", ts.live_grep, { desc = "[F]ind [G]rep" })
  map("n", "<leader>fd", ts.diagnostics, { desc = "[F]ind [D]iagnostics" })
  map("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "[F]ind [T]odo" })

  map('n', '<leader>fo', ts.oldfiles, { desc = '[F]ind recently [O]pened files' })
  map('n', '<leader>f<space>', ts.buffers, { desc = '[F_] Find existing buffers' })
  map('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    ts.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle Explorer', silent = true})
  map('n', '<leader>E', ':NvimTreeFocus<CR>', { desc = 'Focus Explorer', silent = true })
end

M.imap = function(tbl)
  vim.keymap.set("i", tbl[1], tbl[2], tbl[3])
end

M.nmap = function(tbl)
  vim.keymap.set("i", tbl[1], tbl[2], tbl[3])
end

M.buf_nnoremap = function(opts_tbl)
  if opts_tbl[3] == nil then
    opts_tbl[3] = {}
  end
  opts_tbl[3].buffer = 0

  M.nmap(opts_tbl)
end

M.buf_inoremap = function(opts_tbl)
  if opts_tbl[3] == nil then
    opts_tbl[3] = {}
  end
  opts_tbl[3].buffer = 0

  M.imap(opts_tbl)
end


return M
