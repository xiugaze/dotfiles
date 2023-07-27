local M = {}

local opts_any = { noremap = true, silent = true }

-- Basic Keymaps + Functions
local maps = {
    -- note: [key] is long-form syntax for any value as a key. i.e. needed for string keys
    -- mode = {
    --     [input sequence] = output
    -- }
    any = {
        ["<leader>y"] = "\"+y",
        ["<leader>p"] = "\"+p",
        ["<leader>sh"] = ":set list!<CR>",
        ["<leader>t"] = "<C-6>",
        ["q:"] = "<nop>",
        ["H"] = "^",
        ["L"] = "$",
    },
    normal_mode = {
        ["E"] = "ge",
    },
    insert_mode = {
        ["<C-BS>"] = "<C-W>",
        ["<C-H>"] = "<C-W>",
    },
    visual_mode = {
        -- stay in indent
        ["<"] = "<gv",
        [">"] = ">gv",
    },
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

function M.set_keymap(mode, input, output)
    --local opts = opts[mode] or opts_any
    vim.keymap.set(mode, input, output, opts_any)
end

-- load basic keybinds
function M.load_basics()
    for mode, mappings in pairs(maps) do
        mode = mode_adapters[mode] or mode      -- mode = mode character
        for input, output in pairs(mappings) do -- for input/output pairing
            M.set_keymap(mode, input, output)
        end
    end
    -- Remap for dealing with word wrap
    vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
    vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
end

-- Normal mode map with descriptions
function M.nmap(input, output, desc)
    vim.keymap.set("n", input, output, { noremap = true, silent = true, desc = desc })
end

function M.load_plugins()
    local map = M.nmap
    map("<C-f>", ":lua vim.lsp.buf.format()<CR>", "Format")
    map("<leader>e", "<cmd>Neotree toggle float<cr>", "Explorer (Neotree)")
    map("<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", "Tmux Left")
    map("<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", "Tmux Down")
    map("<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", "Tmux Up")
    map("<leader>ll", M.toggle_lines, "Toggle lsp_lines")
    map("<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", "Tmux Right")

    -- See `:help telescope.builtin`
    local builtin = require('telescope.builtin')
    map('<leader>?', builtin.oldfiles, '[?] Find recently opened files')
    map('<leader><space>', builtin.buffers, '[ ] Find existing buffers')
    map('<leader>fb', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end, '[/] Fuzzily search in current buffer')

    map('<leader>fgf', builtin.git_files, '[F]ind [G]it [F]iles')
    map('<leader>fgs', builtin.git_status, '[F]ind [G]it [S]tatus')
    map('<leader>ff', builtin.find_files, '[F]ind [F]iles')
    map('<leader>fh', builtin.help_tags, '[F]ind [H]elp')
    map('<leader>fs', builtin.live_grep, '[F]ind by [S]tring (with grep)')
    map('<leader>fD', builtin.diagnostics, '[F]ind Workspace [D]iagnostics')
    map('<leader>fi', builtin.lsp_implementations, '[F]ind [I]mplementation')
    map('<leader>fd', function()
        local opts = { bufnr = 0, }
        require("telescope.builtin").diagnostics(opts)
    end, '[F]ind [D]iagnostics')
    map('<leader>fm', ":Telescope noice<CR>", '[F]ind [M]essages')
    map('<leader>fa', ":Telescope aerial<CR>", '[F]ind [M]essages')
    map('<leader>ft', ":TodoTelescope<CR>", '[F]ind [T]odo')
    -- zenmode
    map('<leader>z', ":ZenMode<CR>", '[Z]enmode')
end

M.toggle_lines = function()
    local current = vim.diagnostic.config().virtual_lines
    local new_value
    if current == false then
        new_value = { only_current_line = true }
    else
        new_value = false
        vim.diagnostic.config({ virtual_lines = new_value })
    end


    vim.diagnostic.config({ virtual_lines = new_value })
    return new_value
end

M.load_basics()
M.load_plugins()

return M
