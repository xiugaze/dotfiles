local keymaps = {
  -- any
  [""] = {
    ["Y"] = "\"+y",
    ["P"] = "\"+p",
    ["L"] = "g$",
    ["E"] = "ge",
    ["H"] = "g^",
  },
  -- normal mode
  ["n"] = {
    -- ["<leader>y"] = "\"+y",
    -- ["<leader>p"] = "\"+p",
    -- ["<leader>sh"] = ":set list!<CR>", -- hide list (visible spaces, etc)
    ["q:"] = "<nop>",
  },

  -- insert
  ["i"] = {
    -- ctrl-bs
    ["<C-BS>"] = "<C-W>",
    ["<C-H>"] = "<C-W>",
  },

  -- visual
  ["v"] = {
    ["<"] = "<gv",
    [">"] = ">gv",
  },

  -- visual block
  ["x"] = {},

  -- operator pending
  ["o"] = {},

  -- terminal
  ["t"] = {},

  -- command
  ["c"] = {},
}

local function map(mode, input, output, desc)
  vim.keymap.set(mode, input, output, { noremap = true, silent = true, desc = desc or "" })
end

local function nmap(input, output, desc)
  vim.keymap.set("n", input, output, { noremap = true, silent = true, desc = desc or "" })
end


-- basic keymaps
for mode, maps in pairs(keymaps) do
  for i, o in pairs(maps) do
    map(mode, i, o)
  end
end

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- telescope

local ts = require("telescope.builtin")
nmap("<leader>ff", ts.find_files, "[f]ind [f]iles")
nmap("<leader>fw", ts.grep_string, "[f]ind [w]ord")
nmap("<leader>fg", ts.live_grep, "[f]ind [g]rep")
nmap("<leader>ff", ts.find_files, "[f]ind [f]iles")
nmap("<leader>fd", ts.diagnostics, "[f]ind [d]iagnostics")
-- set("<leader>fr", builtin.resume, "[f]ind [r]esume") -- don't understand this
nmap("<leader>f.", ts.oldfiles, "[f]ind recent files")
nmap("<leader>fs", ts.builtin, "[f]ind [s]elect")
nmap("<leader>fk", ts.keymaps, "[f]ind [k]eymaps")
nmap("<leader>fr", ":lua require'telescope.builtin'.lsp_references(require('telescope.themes').get_dropdown({}))<cr>", "[f]ind [r]eferences")
nmap("<leader>ft", ts.treesitter, "[f]ind [t]reesitter")
nmap("<leader>fn", function()
  ts.find_files { cwd = vim.fn.stdpath 'config' }
end, "[S]earch [N]eovim files")


nmap("<C-f>", ":lua vim.lsp.buf.format()<CR>", "Format")
nmap("-", "<CMD>Oil<CR>",  "Open parent directory")


vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local builtin = require("telescope.builtin")
    local map = function(input, output, desc)
      vim.keymap.set('n', input, output, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- gotos
    map("gd", builtin.lsp_definitions, "[g]oto [d]efinition")
    map("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
    map("gr", builtin.lsp_references, "[g]oto [r]eferences")
    map("gI", builtin.lsp_implementations, "[g]oto [I]mplementation")
    map("gs", builtin.lsp_document_symbols, "[g]oto [s]ymbols")
    map("gS", builtin.lsp_dynamic_workspace_symbols, "[g]oto workspace [S]ymbols")
    map("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")
    map("gh", function()
      vim.lsp.buf.hover { border = "rounded", max_height = 25, max_width = 80 }
    end, "[g]oto [h]elp (Hover Documentation)")
  end
})



