" Enable modern Vim features not compatible with Vi spec.
set nocompatible

filetype off

" Install vim-plug if it's not found
" (from https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation).
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'blueshirts/darcula'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'godlygeek/csapprox'
Plug 'hdima/python-syntax'
Plug 'rbgrouleff/bclose.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'idanarye/vim-vebugger'
"Plug 'vhdirk/vim-cmake'

call plug#end()

let s:private_file = $HOME . '/.private.vim'
if filereadable(s:private_file)
  execute 'source ' . s:private_file
endif

" Editor settings
set number
set ignorecase
set colorcolumn=81
set t_Co=256  " 256 colors
set smartcase
set expandtab
set autoindent

" Enable file type based indent configuration and syntax highlighting.
filetype plugin indent on
syntax on
setlocal ts=2 sts=2 sw=2
autocmd Filetype * setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2  " Ruby
autocmd Filetype haskell setlocal ts=2 sts=2 sw=2  " Haskell

" Enable mouse support
set ttyfast  " Send more characters for redraws
set mouse=a  " Use mouse in all modes
set ttymouse=xterm2  " Must be: xterm, xterm2, netterm, dec, jsbterm, pterm

if has('gui_running')
  set guioptions-=T  " No toolbar
  set guioptions-=m  " No menu
  if has('unix')
    set guifont=Monospace\ 9
  endif
endif

" YouCompleteMe shortcuts
inoremap <C-Space> <C-x><C-o>
autocmd Filetype c,cpp,python,go noremap <C-g> :YcmCompleter GoTo<CR>
autocmd Filetype c,cpp noremap <leader>ct :YcmCompleter GetType<CR>
"autocmd Filetype c,cpp noremap <C-r> :FixIt<CR>
"autocmd Filetype c,cpp,python noremap <C-x> :GetDoc<CR>
let g:ycm_filetype_blacklist = { 'python': 1 }
let g:ycm_disable_for_files_larger_than_kb = 1500

" Show tab line.
let g:airline#extensions#tabline#enabled = 1
noremap <C-j> :bp<CR>
noremap <C-k> :bn<CR>

" CtrlP config
let g:private_ctrlp_flags = ""
let g:ctrlp_user_command = '/usr/bin/ag %s -i --nocolor --nogroup --hidden
  \ --ignore .git
  \ --ignore .svn
  \ --ignore .hg
  \ --ignore .DS_store
  \ --ignore "**/*.pyc"
  \ -g "" ' . g:private_ctrlp_flags

" Bclose
nnoremap <C-w>d :Bclose<CR>
cnoreabbrev bc Bclose

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" vim-cmake
let g:cmake_export_compile_commands = 1

" Edit vimrc (Edit Rc)
nnoremap <leader>er :e ~/.vimrc<CR>

" Color scheme.
colorscheme darcula

" NERDTree toggle.
nnoremap <leader>n :NERDTreeToggle<CR>

" Save shortcuts.
nnoremap <C-s> :w<CR>
vnoremap <C-s> :w<BS><BS><BS><BS><BS><CR>
inoremap <C-s> <C-o>:w<CR>
nnoremap <M-q> :q<CR>

" Ctrl-backspace to delete words.
inoremap <C-BS> <C-w>

" Comment shortcuts.
nnoremap <C-/> gcc
vnoremap <C-/> gc

" Shift-tab outdents
inoremap <S-Tab> <C-d>
