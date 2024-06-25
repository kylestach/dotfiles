" Set <space> as the leader key
let mapleader = ' '
let maplocalleader = ' '

" Set to true if you have a Nerd Font installed and selected in the terminal
let g:have_nerd_font = 0

" Make line numbers default
set number
set relativenumber

" Enable mouse mode
set mouse=a

" Don't show the mode, since it's already in the status line
set noshowmode

" Sync clipboard between OS and Vim
set clipboard+=unnamedplus

" Enable break indent
set breakindent

" Save undo history
set undofile

" Case-insensitive searching UNLESS \C or capital letters in the search term
set ignorecase
set smartcase

" Keep signcolumn on by default
set signcolumn=yes

" Decrease update time
set updatetime=250

" Decrease mapped sequence wait time
set timeoutlen=300

" Configure how new splits should be opened
set splitright
set splitbelow

" Sets how vim will display certain whitespace characters in the editor
set list
set listchars=tab:»\ ,trail:·,nbsp:␣

" Preview substitutions live, as you type!
set inccommand=split

" Show which line your cursor is on
set cursorline

" Minimal number of screen lines to keep above and below the cursor
set scrolloff=10

" Set highlight on search, but clear on pressing <Esc> in normal mode
set hlsearch
nnoremap <Esc> :nohlsearch<CR>

" Open command mode with ;
nnoremap ; :

" Keybinds to make split navigation easier
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
