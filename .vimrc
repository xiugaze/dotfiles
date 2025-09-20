set nu rnu 

:set autoindent
:set tabstop=4
:set shiftwidth=4 
:set smarttab
:set softtabstop=4
:set mouse=i
set viminfo+='1000,n~/.config/vim/viminfo

let mapleader = ";"
set encoding=UTF-8
set clipboard=unnamedplus
nnoremap <leader>y "+y
nnoremap <leader>p "+p

map H ^
map L $
map E ge
map K ~

vmap < <gv
vmap > >gv

map <leader>j <C-w>w

map <leader>l :tabn<CR>
map <leader>h :tabp<CR>

