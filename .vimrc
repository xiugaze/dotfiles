set nu rnu 

:set autoindent
:set tabstop=4
:set shiftwidth=4 
:set smarttab
:set softtabstop=4
:set mouse=a

" leader key
let mapleader = ";"


call plug#begin()
Plug 'lervag/vimtex'
Plug 'https://github.com/preservim/nerdtree' " NerdTree
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'https://github.com/vim-airline/vim-airline' " Status bar
Plug 'https://github.com/ap/vim-css-color' " CSS Color Preview
Plug 'https://github.com/smithbm2316/centerpad.nvim'
Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}
" you have to :CocInstall coc-rust-analyzer
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons
Plug 'https://github.com/bling/vim-bufferline'
Plug 'https://github.com/tc50cal/vim-terminal' " Vim Terminal
Plug 'https://github.com/preservim/tagbar' " Tagbar for code navigation
Plug 'https://github.com/terryma/vim-multiple-cursors' " CTRL + N for multiple cursors
" Plug 'https://github.com/kassio/neoterm' " terminal
Plug 'https://github.com/sheerun/vim-polyglot' "polygot
Plug 'https://github.com/joshdick/onedark.vim' " onedark
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'https://github.com/rvighne/vim-one'
Plug 'https://github.com/alisdair/vim-armasm' "asm syntax
Plug 'https://github.com/ARM9/arm-syntax-vim'
Plug 'https://github.com/christoomey/vim-tmux-navigator'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'vim-airline/vim-airline-themes' "
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'https://github.com/junegunn/rainbow_parentheses.vim'

set encoding=UTF-8

call plug#end()

lua << EOF
  require("todo-comments").setup {
  }
EOF

au BufNewFile,BufRead *.s,*.S set filetype=arm " arm = armv6/7"

" COC Configuration
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

" Carriage Return (Enter) for selecting 
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" enable autofill
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

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gh :call <SID>show_documentation()<CR>
nmap <leader>qf <Plug>(coc-fix-current)

" ###########################################################


" #################### NERDTree ############################
nnoremap <leader>f :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

" ##########################################################

nnoremap <C-p> :CtrlP<CR>


" ##### Simple Keybinds
" Copy/Paste from System Clipboard
set clipboard=unnamedplus
nnoremap <leader>y "+y
nnoremap <leader>p "+p

map H ^
map L $
map E ge
map K ~

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

map <leader>j <C-w>w

"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >"

if (has("termguicolors"))
  set termguicolors
endif

syntax on
colorscheme one
set background=dark
let g:airline_theme='onehalfdark'

nnoremap <silent><leader>z <cmd>Centerpad<cr>

map <leader>l :tabn<CR>
map <leader>h :tabp<CR>

let g:vimtex_view_method = 'zathura'
let g:tex_flavor = 'latex'

