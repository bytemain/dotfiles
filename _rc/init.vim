filetype on
filetype indent on
syntax on

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set rnu
    autocmd BufLeave,FocusLost,InsertEnter   * set nornu
augroup END
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf

set listchars=tab:>-,trail:~,extends:>,precedes:<,nbsp:-
set list
set nocompatible
set nu
set nospell
set hlsearch
set smartcase
set encoding=utf-8
set paste
set noswapfile
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set copyindent
set autoindent
set cursorline
set shortmess+=filmnrxoOtT

set showmatch
set showmode
set showcmd
set mouse=a

call plug#begin(stdpath('data') . '/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Initialize plugin system
call plug#end()
