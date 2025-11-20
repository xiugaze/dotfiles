local keymaps = {
  -- any
  [""] = {
    ["<leader>y"] = "\"+y",
    ["<leader>p"] = "\"+p",
    ["<leader>l"] = ":tabn<CR>",
    ["<leader>h"] = ":tabp<CR>",
    -- ["Y"] = "\"+y",
    -- ["P"] = "\"+p",
    ["L"] = "g$",
    ["E"] = "ge",
    ["H"] = "g^",
  },
  -- normal mode
  ["n"] = {
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

function insertFullPath()
  local filepath = vim.fn.expand('%')
  vim.fn.setreg('+', filepath) -- write to clippoard
end

vim.keymap.set('n', '<leader>pc', insertFullPath, { noremap = true, silent = true })

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

nmap("<leader>tt", function()
  if vim.o.background == "dark" then
    vim.o.background = "light";
    require("catppuccin").setup({transparent_background = false, flavor = "latte"})
    vim.cmd.colorscheme "catppuccin"
  else
    vim.o.background = "dark";
    require("catppuccin").setup({transparent_background = true, flavor = "macchiato"})
    vim.cmd.colorscheme "catppuccin"
  end
end, "switch light dark")

-- telescope

local ts = require("telescope.builtin")

nmap("<leader>ff", ts.find_files, "[f]ind [f]iles")
nmap("<leader>fq", ts.oldfiles, "find old")
nmap("<leader>fw", ts.grep_string, "[f]ind [w]ord")
nmap("<leader>fg", ts.live_grep, "[f]ind [g]rep")
nmap("<leader>ff", ts.find_files, "[f]ind [f]iles")
nmap("<leader>fd", ts.diagnostics, "[f]ind [d]iagnostics")
nmap("<leader>fe", "<cmd>Telescope oil<CR>", "[f]ind [d]iagnostics")
nmap("<leader>fr", ts.resume, "[f]ind [r]esume") -- don't understand this
nmap("<leader>f.", ts.oldfiles, "[f]ind recent files")
nmap("<leader>fS", ts.builtin, "[f]ind [s]elect")
nmap("<leader>fk", ts.keymaps, "[f]ind [k]eymaps")
nmap("<leader>fb", ts.current_buffer_fuzzy_find, "[f]ind [b]uffer")
-- nmap("<leader>fR", ":lua require'telescope.builtin'.lsp_references(require('telescope.themes').get_dropdown({}))<cr>", "[f]ind [r]eferences")
nmap("<leader>fR", ts.lsp_references, "[f]ind [r]eferences")
nmap("<leader>foc", ts.lsp_outgoing_calls, "[f]ind [o]utgoing [c]alls")
nmap("<leader>fic", ts.lsp_incoming_calls, "[f]ind [i]ncoming [c]alls")
nmap("<leader>ft", ts.treesitter, "[f]ind [t]reesitter")
nmap("<leader>fs", ts.lsp_document_symbols, "[f]ind lsp [s]ymbols")
nmap("<leader>fn", function()
  ts.find_files { cwd = vim.fn.stdpath 'config' }
end, "[S]earch [N]eovim files")
nmap("<leader>fN", function()
  ts.find_files { cwd = '~/.dotfiles/nixos' }
end, "[f]ind [n]ixos files")

require('telescope').load_extension('box-drawing')
nmap("<leader>fx", require('telescope').extensions['box-drawing']['box-drawing'], "[f]ind bo[x]")


nmap("<leader>fs", ts.lsp_document_symbols, "[f]ind lsp [s]ymbols")

nmap("<leader>dd", ":Neogen<CR>", "[dd]ocumentation")
nmap("<leader>ng", require("neogit").open)


nmap("<C-f>", vim.lsp.buf.format, "Format")
nmap("-", "<CMD>Oil<CR>",  "Open parent directory")

-- nmap("<C-e>", require('render-markdown').toggle)

-- nmap("<leader>m", function ()
--   require("blink.cmp").setup({ completion = { menu = { enabled = false }}})
-- end)


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


local ls = require("luasnip")

vim.keymap.set({"i"}, "<M-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

-- vim.keymap.set({"i", "s"}, "<C-e>", function()
--     if ls.choice_active() then
--         ls.change_choice(1)
--     end
-- end, {silent = true})
-- loaded!!
--
--
-- load the session for the current directory
vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end)
-- select a session to load
vim.keymap.set("n", "<leader>qS", function() require("persistence").select() end)
-- load the last session
vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end)
-- stop Persistence => session won't be saved on exit
vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end)



