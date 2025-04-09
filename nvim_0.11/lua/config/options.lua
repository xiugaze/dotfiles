vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.diagnostic.config {
  underline = true,
  virtual_text = false,
  signs = true,
  severity_sort = true,
}

local options = {
    number = true,          -- show linenumbers
    relativenumber = true,  -- relative line numbers
    list = true,           -- invisible characters
    listchars = { 
        tab = '» ', 
        trail = '·', 
        nbsp = '␣' , 
        -- eol = '¬'
    },

    winborder = "single",
    ignorecase = true,      -- ignore case when searches
    smartcase = true,       -- don't igore case when first is caps
    termguicolors = true,   -- truecolor terminals
    wrap = false,           -- linewrapping
    shiftround = true,     -- indent rounding
    shiftwidth = 2,         -- indent size
    tabstop = 2,            -- how many spaces a tab is
    softtabstop = 2,
    splitbelow = true,      -- buffers can split below
    splitright = true,      -- buffers split right 
    mouse = "a",            -- mouse enabled in all modes
    showtabline = 1,        -- tabline when two or more tabs
    undofile = true,        -- undos are stored
    undolevels = 10000,     -- maximum number of undos

    --updatetime = 100,       -- when swapfile is written
    swapfile = false,

    sidescrolloff = 8,      -- keep columns left and right cursor
    scrolloff = 6,          -- keep lines above and below cursor
    pumheight = 12,         -- maximum popup items
    signcolumn = "yes:1",     -- display the signcolumn always
    hlsearch = true,        -- highlight all search results

    -- not sure what these are
    foldmethod = "manual",
    hidden = true,
    cmdheight = 0,
    conceallevel = 1,

    -- from kickstart
    cursorline = true,
    inccommand = 'split',
    -- Displays which-key popup sooner
    timeoutlen = 500,
    -- swapfile write time
    updatetime = 250,
    showmode = true,
    breakindent = true,
    expandtab = true,       -- tabs expand to spaces
}

local load = function(opts) 
    -- disable netrw
    for k, v in pairs(opts) do 
        vim.opt[k] = v
    end
    vim.opt.shortmess:append "c"
    vim.opt.iskeyword:remove("_")
    -- vim.opt.shortmess:append "I" -- don't show the intro

    -- moving left/right wraps to next line
    -- vim.opt.whichwrap:append "<,>,[,],h,l" 
end

load(options)
