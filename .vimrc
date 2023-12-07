set nu rnu 

:set autoindent
:set tabstop=4
:set shiftwidth=4 
:set smarttab
:set softtabstop=4
:set mouse=a
set viminfo+='1000,n~/.config/vim/viminfo

" leader key
let mapleader = ";"
set encoding=UTF-8

" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gt <Plug>(coc-type-definition)
" nmap <silent> gr <Plug>(coc-references)
" nmap <silent> gi <Plug>(coc-implementation)
" nnoremap <silent> gh :call <SID>show_documentation()<CR>
" nmap <leader>qf <Plug>(coc-fix-current)
" ###########################################################

set clipboard=unnamedplus
nnoremap <leader>y "+y
nnoremap <leader>p "+p

map H ^
map L $
map E ge
map K ~

map <leader>j <C-w>w

map <leader>l :tabn<CR>
map <leader>h :tabp<CR>

