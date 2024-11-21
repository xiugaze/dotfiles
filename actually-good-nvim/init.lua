vim.g.maplocalleader = ";"

vim.g.mapleader = ";"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.o.laststatus = 0



-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)
-- NOTE: `opts = {}` is the same as calling `require('plugin').setup({})`
require("lazy").setup({

    { "folke/neoconf.nvim",            cmd = "Neoconf" },
    { 'christoomey/vim-tmux-navigator' },
    { "ixru/nvim-markdown" },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    'vimpostor/vim-tpipeline',
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            routes = {
                {
                    filter = {
                        event = "lsp",
                        kind = "progress",
                        find = "jdtls",
                    },
                    opts = { skip = true },
                },
            },
            presets = {
                bottom_search = true,         -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false,       -- add a border to hover docs and signature help
            },
            messages = {
                view = "mini",
                view_error = "mini",
                view_warn = "mini",
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    },
    {
        -- 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        -- config = function()
        --     vim.diagnostic.config({
        --         virtual_text = false,
        --         virtual_lines = { only_current_line = true },
        --     })
        --     require('lsp_lines').setup()
        -- end
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            -- Useful status updates for LSP
            --{ 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
            -- Additional lua configuration, makes nvim stuff amazing!
            { 'folke/neodev.nvim', },
        },
    },

    {
        'simrat39/rust-tools.nvim',
        dependencies = {
            'Saecki/crates.nvim',
            opts = {},
        },
    },
    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        main = "ibl",
        opts = {
            indent = { char = '┊' },
        },
    },
    { 'numToStr/Comment.nvim',         opts = {} },
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end,
    },

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },
    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
        },
    },
    -- {
    --     "ellisonleao/gruvbox.nvim",
    --     priority = 1000,
    --     config = function()
    --         require("gruvbox").setup({
    --             palette_overrides = {
    --                 dark1 = "#282828",
    --             },
    --         })
    --         vim.o.background = "dark"
    --         vim.cmd([[colorscheme gruvbox]])
    --     end,
    -- },
    -- {
    --     'mcchrish/zenbones.nvim',
    --     config = function()
    --         vim.g.zenbones_compat = 1
    --         vim.o.background = "dark"
    --         vim.cmd([[colorscheme zenbones]])
    --     end
    -- },
    {
        'sainnhe/everforest',
        config = function()
            vim.g.everforest_background = "soft"
            vim.o.background = "dark"
            vim.cmd([[colorscheme everforest]])
            vim.cmd([[highlight Conceal guifg=#d3c6aa]])
        end
    },

    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            vim.o.termguicolors = true
            require('colorizer').setup()
        end,
    },


    { import = "plugins" }

})

-- if os.getenv("THEME") == "dark" then
--     vim.o.background = "dark"
--     vim.cmd([[colorscheme everforest]])
-- else
--     vim.o.background = "light"
--     vim.cmd([[colorscheme everforest]])
-- end


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})
-- opts, keymaps, utils
-- require("plugins")
require("lsp")
require("config")
