local options = {
    number = true,          -- show linenumbers
    relativenumber = true,  -- relative line numbers
    list = false,           -- invisible characters
    listchars = "tab:>\\,eol:¬",
    ignorecase = true,      -- ignore case when searches
    smartcase = true,       -- don't igore case when first is caps
    termguicolors = true,   -- truecolor terminals
    wrap = false,           -- linewrapping
    shiftround = false,     -- indent rounding
    shiftwidth = 4,         -- indent size
    tabstop = 4,            -- how many spaces a tab is
    splitbelow = true,      -- buffers can split below
    splitright = true,      -- buffers split right 
    expandtab = true,       -- tabs expand to spaces
    mouse = "a",            -- mouse enabled in all modes
    showtabline = 1,        -- tabline when two or more tabs
    undofile = true,        -- undos are stored
    undolevels = 10000,     -- maximum number of undos
    --updatetime = 100,       -- when swapfile is written

    sidescrolloff = 8,      -- lines left and right of cursor
    swapfile = false,
    scrolloff = 6,      -- lines left and right of cursor
    pumheight = 12,         -- maximum popup items
    signcolumn = "yes",     -- display the signcolumn always
    hlsearch = true,        -- highlight all search results
    -- not sure what these are
    foldmethod = "manual",
    hidden = true,
    cmdheight = 0,
    conceallevel = 1,
}

local load = function(opts) 
    -- disable netrw
    for k, v in pairs(opts) do 
        vim.opt[k] = v
    end
    vim.opt.shortmess:append "c"
    vim.opt.shortmess:append "I"
    vim.opt.whichwrap:append "<,>,[,],h,l"
end

load(options)
