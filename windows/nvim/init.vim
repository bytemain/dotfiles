set number
set autoindent
set smartindent
set showmatch
set cursorline
set incsearch
set display+=lastline
set noswapfile
set history=1024
set autochdir
set whichwrap=b,s,<,>,[,]
set nobomb
set backspace=indent,eol,start whichwrap+=<,>,[,]
set clipboard=unnamed
set winaltkeys=no
set undofile " keep an undo file (undo changes after closing)
set ruler  " show the cursor position all the time
set showfulltag " show tag with function protype.
set guioptions+=b " present the bottom scrollbar when the longest visible line exceed the window
set fileencodings=utf-8,gbk2312,gbk,gb18030,cp936
set encoding=utf-8
set tenc=utf-8
set listchars=tab:>-,trail:~,extends:>,precedes:<,nbsp:-
set list
set nospell
set smartcase
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set copyindent
set shortmess+=filmnrxoOtT
set showmode
set showcmd
set mouse=a
set shell=powershell shellquote=( shellpipe=\| shellxquote=
set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
set shellredir=\|\ Out-File\ -Encoding\ UTF8
set autoread
set hlsearch

filetype on
filetype indent on

syntax on
syntax enable

if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set guicursor=n-v-c:block,i-ci-ve:ver10,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175

augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set rnu
    autocmd BufLeave,FocusLost,InsertEnter   * set nornu
augroup END

call plug#begin('~/AppData/Local/nvim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'preservim/nerdcommenter'
Plug 'Chiel92/vim-autoformat'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()


source $VIMRUNTIME/mswin.vim
set termguicolors
colorscheme dracula

map <C-b> :NERDTreeToggle<CR>
