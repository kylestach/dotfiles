set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call plug#begin('~/.config/nvim/plugged')

Plug 'VundleVim/Vundle.vim'
Plug 'keith/swift.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'rhysd/vim-clang-format'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
" Plugin 'airblade/vim-gitgutter'
Plug 'davidzchen/vim-bazel'
Plug 'lervag/vimtex'
Plug 'scrooloose/nerdtree'
Plug 'simnalamburt/vim-mundo'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mtth/scratch.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'uarun/vim-protobuf'

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !python2 ./install.py --clang-completer
  endif
endfunction

Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }

call plug#end()
filetype plugin indent on

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

" Don't try to open certain files with CtrlP
set wildignore=*.swp,*.bak,*.pyc

" Fix movement with overflowing lines
nnoremap j gj
nnoremap k gk

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

if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

set mouse=a

let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_insertion = 1

let g:clang_format#detect_styleYfile=1
let g:clang_format#auto_format=1
let g:clang_format#command="clang-format"


let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-n>"
" call add(g:UltiSnipsSnippetDirectories, "~/.vim/custom/snippets")
" let g:UltiSnipsSnippetDirectories = ["UltiSnips", "~/.vim/custom/snippets"]

let g:UltiSnipsExpandTrigger = "<nop>"
let g:ulti_expand_or_jump_res = 0
function ExpandSnippetOrCarriageReturn()
  let snippet = UltiSnips#ExpandSnippetOrJump()
  if g:ulti_expand_or_jump_res > 0
    return snippet
  else
    return "\<CR>"
  endif
endfunction
inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"

let mapleader = "\<SPACE>"

" Airline settings
let g:airline#extensions#tabline#enabled = 2
let g:airline_powerline_fonts = 1

" CtrlP
nnoremap <leader>o :CtrlP<CR>
nnoremap <leader>s :CtrlPBuffer<CR>

" Run the last !-command on leader-r (Usually to run the program)
map <leader>r :wa<CR>:!<Up><CR>

" Open the shell on leader-s
" map <leader>s :sh<CR>

" Allow typing ; instead of SHIFT-; (:) to go into command
nnoremap <leader>; ;
nnoremap ; :

" Code formatting
map <leader>f :ClangFormat<CR>

" Next occurence should center the text
nmap n nzz
nmap N Nzz

nmap <space> zz

nmap <leader>u :MundoToggle<CR>

map <leader>nt :NERDTreeToggle<CR>

" C/C++ settings
augroup cpp_macros " {
  autocmd!
  " Open corresponding header/source file
  autocmd FileType h,c,hpp,cpp nnoremap <leader>h :vsp %<.h<CR>
  autocmd FileType h,c,hpp,cpp nnoremap <leader>c :vsp %<.cpp<CR>

  " Go to definition or declaration
  autocmd FileType h,c,hpp,cpp nnoremap <leader>def :YcmCompleter GoToDefinition<CR>
  autocmd FileType h,c,hpp,cpp nnoremap <leader>dec :YcmCompleter GoToDeclaration<CR>
  autocmd FileType h,c,hpp,cpp nnoremap <leader>inc :YcmCompleter GoToInclude<CR>
augroup end " }

" LaTeX settings
let g:tex_flavor = "latex"

augroup latex_macros
  autocmd!
  autocmd FileType tex :nnoremap <leader>c :w<CR>:!rubber -pdf %<CR>
  autocmd FileType tex :nnoremap <leader>v :!evince %<.pdf >/dev/null 2>/dev/null&<CR><CR>
augroup end

augroup text_macros
  autocmd!
  autocmd FileType tex,text :set tw=120
  autocmd FileType text :set noautoindent
augroup end

" NeoVim only settings
if has("nvim")
  " Split terminal with <leader>t
  nnoremap <leader>t :vsp<CR>:terminal<CR>
  tnoremap <ESC> <C-\><C-n>
  tnoremap <C-w> <C-\><C-n><C-w>
  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert
end

" Reload vimrc
nnoremap <silent> <leader>ve :e $MYVIMRC<CR>
nnoremap <silent> <leader>vr :so $MYVIMRC<CR>

set pastetoggle=<F2>
