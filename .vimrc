set nu rnu 

:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a


call plug#begin()

Plug 'https://github.com/preservim/nerdtree' " NerdTree
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'https://github.com/vim-airline/vim-airline' " Status bar
Plug 'https://github.com/ap/vim-css-color' " CSS Color Preview
Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons
Plug 'https://github.com/tc50cal/vim-terminal' " Vim Terminal
Plug 'https://github.com/preservim/tagbar' " Tagbar for code navigation
Plug 'https://github.com/terryma/vim-multiple-cursors' " CTRL + N for multiple cursors
Plug 'https://github.com/ctrlpvim/ctrlp.vim'
" Plug 'https://github.com/kassio/neoterm' " terminal
Plug 'https://github.com/sheerun/vim-polyglot' "polygot
Plug 'https://github.com/joshdick/onedark.vim' " onedark
Plug 'mangeshrex/everblush.vim' "everblush

set encoding=UTF-8

call plug#end()

nnoremap <C-f> :NERDTreeFocus<CRo>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-p> :CtrlP<CR>

map H ^
map L $
map E ge



map K ~


syntax on
colorscheme everblush

map K 
