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
        for input, output in pairs(mappings) do    -- for input/output pairing
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
    map("<leader>e", "<cmd>Neotree toggle float<cr>", "Explorer (Neotree)")
    map("<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", "Tmux Left")
    map("<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", "Tmux Down")
    map("<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", "Tmux Up")
    map("<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", "Tmux Right")
end

M.load_basics()
M.load_plugins() 

return M
            
