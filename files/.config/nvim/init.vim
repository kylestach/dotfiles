set nocompatible
filetype off

"""""""""""""""""""" Plugins and plugin settings """"""""""""""""""""

set rtp+=~/.vim/bundle/Vundle.vim
call plug#begin('~/.config/nvim/plugged')
Plug 'VundleVim/Vundle.vim'

" Utilities
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'simnalamburt/vim-mundo'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'

" Look and feel
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'altercation/vim-colors-solarized'

" Language support
Plug 'elixir-lang/vim-elixir'
Plug 'uarun/vim-protobuf'
Plug 'rust-lang/rust.vim'
Plug 'davidzchen/vim-bazel'
Plug 'keith/swift.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'cstrahan/vim-capnp'

" Miscellaneous
Plug 'mtth/scratch.vim'
Plug 'neilagabriel/vim-geeknote'

" IDE-like
" YCM: Rebuild when necessary and defer loading until a cpp file is opened
function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !python2 ./install.py --clang-completer
  endif
endfunction
" Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') } " , 'on': [] }
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'rhysd/vim-clang-format' | Plug 'kana/vim-operator-user'

call plug#end()

" CtrlP settings
set wildignore=*.swp,*.bak,*.pyc

" Ultisnips settings
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-n>"
let g:UltiSnipsExpandTrigger = "<nop>"
let g:ulti_expand_or_jump_res = 0

function! ExpandSnippetOrCarriageReturn()
  let snippet = UltiSnips#ExpandSnippetOrJump()
  if g:ulti_expand_or_jump_res > 0
    return snippet
  else
    return "\<CR>"
  endif
endfunction
inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"

" Clang-format settings
let g:clang_format#detect_styleYfile=0
let g:clang_format#auto_format=1
let g:clang_format#command="clang-format"

" Airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Geeknote settings
let g:GeeknoteFormat="markdown"

" YouCompleteMe settings
let g:ycm_global_ycm_extra_conf = "~/.config/nvim/.ycm_extra_conf.py"
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_insertion = 1
filetype plugin indent on

"""""""""""""""""" End plugins and plugin settings """"""""""""""""""

""""""""""""""""""""""" General vim settings """"""""""""""""""""""""

" Syntax highlighting
set t_Co=256
set background=dark
colorscheme solarized
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE
syntax enable

" General settings
set number
set scrolloff=3
set sidescrolloff=5
set laststatus=2
set ttimeoutlen=50

set showcmd
set showmatch
set showmode
set ruler
set formatoptions+=o

set title

" Whitespace setting
set textwidth=0
set expandtab
set shiftwidth=2
set tabstop=2

set noerrorbells
set modeline
set esckeys
set linespace=0
set nojoinspaces

set splitbelow

" Search settings
set hlsearch
set incsearch
set magic
set hidden

" Type :w!! to write using sudo
cmap w!! w !sudo tee % >/dev/null

" Only use mouse in normal mode
set mouse=n

set pastetoggle=<F2>

""""""""""""""""""""" End general vim settings """"""""""""""""""""""

""""""""""""""""""""""""""" Key-bindings """"""""""""""""""""""""""""

" Use space as the leader
let mapleader = "\<SPACE>"

" Fix movement with overflowing lines
nnoremap j gj
nnoremap k gk
"
" Run the last !-command on leader-r (Usually to run the program)
map <leader>r :wa<CR>:!<Up><CR>

" Open the shell on leader-s
" map <leader>s :sh<CR>

" Use semicolon (;) instead of colon (Shift-;) to enter command mode
nnoremap <leader>; ;
nnoremap ; :

" While searching, center the text on the result
nmap n nzz
nmap N Nzz

" Clear the search with <leader>/
nnoremap <leader>/ :nohlsearch<CR>

" Space to center
nmap <space> zz

" Reload vimrc with <leader>vr and edit with <leader>ve
nnoremap <silent> <leader>ve :e $MYVIMRC<CR>
nnoremap <silent> <leader>vr :so $MYVIMRC<CR>


nnoremap <leader>o :CtrlP<CR>
nnoremap <leader>s :CtrlPBuffer<CR>

map <leader>f :ClangFormat<CR>

map <leader>nt :NERDTreeToggle<CR>

nmap <leader>u :MundoToggle<CR>

""""""""""""""""""""""""" End key-bindings """"""""""""""""""""""""""

""""""""""""""" Language and context-specific settings """"""""""""""
" C/C++ settings
augroup cpp_macros " {
  autocmd!

  " Open corresponding header/source file
  autocmd FileType cpp nnoremap <leader>h :vsp %<.h<CR>
  autocmd FileType cpp nnoremap <leader>c :vsp %<.cpp<CR>

  " Go to definition or declaration
  autocmd FileType cpp nnoremap <leader>def :YcmCompleter GoToDefinition<CR>
  autocmd FileType cpp nnoremap <leader>dec :YcmCompleter GoToDeclaration<CR>
  autocmd FileType cpp nnoremap <leader>inc :YcmCompleter GoToInclude<CR>

  " Load YCM for cpp files
  " autocmd FileType cpp call plug#load('YouCompleteMe')
augroup end " }

" LaTeX settings
augroup latex_macros
  autocmd!
  autocmd FileType tex Plug 'lervag/vimtex'
    let g:tex_flavor = "latex"
    nnoremap <leader>c :w<CR>:!rubber -pdf %<CR>
    nnoremap <leader>v :!evince %<.pdf >/dev/null 2>/dev/null&<CR><CR>
augroup end

" Text and markdown settings
augroup text_macros
  autocmd!
  autocmd FileType tex,text,markdown :set tw=120
  autocmd FileType text :set noautoindent
augroup end

" NeoVim only settings and features
if has("nvim")
  " Split terminal with <leader>t
  nnoremap <leader>t :vsp<CR>:terminal<CR>
  tnoremap <ESC> <C-\><C-n>
  tnoremap <C-w> <C-\><C-n><C-w>
  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert
end
""""""""""""" End language and context-specific settings """"""""""""
