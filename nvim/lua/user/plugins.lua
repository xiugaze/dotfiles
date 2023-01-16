local fn = vim.fn

-- Automatically install packer
-- Bootstrap script from Packer git repository
-- data is ~/.local/share/nvim
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    vim.notify("Error: Something went wrong with Packer")
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Install your plugins here
return packer.startup(function(use)

    -- My plugins here
    use "wbthomason/packer.nvim" -- Have packer manage itself


    -- DEPENDENCIES --
    -- a lot of plugins need these two as dependencies
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

----- DEEP UTILS --

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    -- navigate around panes in tmux and vim
    -- must be installed in tmuxconf, look at git repo if any issues
    use 'christoomey/vim-tmux-navigator'

    use { 'nvim-telescope/telescope.nvim', tag = '0.1.0' }
    use { 'nvim-telescope/telescope-fzf-native.nvim',
        run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }


    -- autocompletion
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lua'
    use "saadparwaiz1/cmp_luasnip" -- snippet completions
    use 'ray-x/cmp-treesitter'

    -- nvimtree
    use 'nvim-tree/nvim-tree.lua'
    use 'nvim-tree/nvim-web-devicons'

------ SHALLOW UTILS
    --
    -- autopairs
    use "windwp/nvim-autopairs"
    -- snippets
    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'

    -- comments
    use 'terrortylor/nvim-comment'
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup()
        end
    }

    use 'glepnir/template.nvim'

    -- indent lines
    use 'lukas-reineke/indent-blankline.nvim'

----- LANGUAGES ------

    -- lsp:
    use "williamboman/mason.nvim"           -- simple to use language server installer
    use "williamboman/mason-lspconfig.nvim" -- lspconfig drop in

    -- latex support: only on tex filetpes
    use { "lervag/vimtex", ft = { "tex", "lyx" } }

    -- rust




    use "simrat39/rust-tools.nvim"









    use {
        'saecki/crates.nvim',
        tag = 'v0.3.0',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup()
        end,
    }

    -- assembly
    use 'ARM9/arm-syntax-vim'

    -- markdown
    use {
        'lukas-reineke/headlines.nvim',
        config = function()
            require("headlines").setup({
                markdown = {
                    headline_highlights = {
                        "Headline1",
                        "Headline2",
                        "Headline3",
                        "Headline4",
                        "Headline5",
                        "Headline6",
                    },
                    codeblock_highlight = "CodeBlock",
                    dash_highlight = "Dash",
                    quote_highlight = "Quote",
                },
            })
        end,
    }

    -- PERSONALIZATION
    -- some colorschemes
    use 'lunarvim/colorschemes'
    use 'rakr/vim-one'
    use 'shaunsingh/nord.nvim'

    -- gitsigns
    use 'lewis6991/gitsigns.nvim'

    -- ORGANIZATION
    --obsidian
    use 'epwalsh/obsidian.nvim'
    use {'nvim-orgmode/orgmode', config = function()
      require('orgmode').setup{}
    end
    }








    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
