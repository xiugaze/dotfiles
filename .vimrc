set nu rnu 

:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a

let mapleader = ";"
set clipboard=unnamedplus
" you have to :CocInstall coc-rust-analyzer
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
Plug 'https://github.com/alisdair/vim-armasm' "asm syntax

set encoding=UTF-8

call plug#end()



" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" trigger autocomplete menu
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif



function! s:show_documentation()
	if &filetype == 'vim' 
		execute 'h '.expand('<cword>')
	else 
		call CocAction('doHover')
	endif
endfunction


nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-p> :CtrlP<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gh :call <SID>show_documentation()<CR>

inoremap <M-BS> <C-o>db

nnoremap <leader>y "+y
nnoremap <leader>p "+p

map H ^
map L $
map E ge



map K ~


syntax on
colorscheme everblush

map K 

