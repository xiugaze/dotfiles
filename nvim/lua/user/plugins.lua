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

  -- a lot of plugins need these two as dependencies
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

  -- latex support: only on tex filetpes
  use { "lervag/vimtex", ft = { "tex", "lyx" } }

  -- TreeSitter: don't actually understand what this does, 

  -- something something abstract syntax tree
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {'nvim-telescope/telescope.nvim',  tag = '0.1.0' }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  
  -- navigate around panes in tmux and vim
  -- must be installed in tmuxconf, look at git repo if any issues
  use 'christoomey/vim-tmux-navigator'
 
  -- some colorschemes 
  use 'lunarvim/colorschemes'
  use 'rakr/vim-one'

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

  --obsidian
  use 'epwalsh/obsidian.nvim'

  -- snippets
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'

  -- lsp:
  use "williamboman/mason.nvim" -- simple to use language server installer
  use "williamboman/mason-lspconfig.nvim" -- simple to use language server installer

  -- autopairs
  use "windwp/nvim-autopairs"

  -- gitsigns
  use 'lewis6991/gitsigns.nvim'
  -- indent lines
  use 'lukas-reineke/indent-blankline.nvim'

  -- nvimtree
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'

  -- comments
 use 'terrortylor/nvim-comment'
	use {
	  "folke/todo-comments.nvim",
	  requires = "nvim-lua/plenary.nvim",
	  config = function()
		require("todo-comments").setup()
		  -- your configuration comes here
		  -- or leave it empty to use the default settings
		  -- refer to the configuration section below
		
		end
	}

  -- rust
  --use "simrat39/rust-tools.nvim"
  
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




  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
