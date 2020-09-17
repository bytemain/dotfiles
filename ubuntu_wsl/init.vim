filetype on
filetype plugin on
filetype indent on
syntax on
" Protect changes between writes. Default values of
" updatecount (200 keystrokes) and updatetime
" (4 seconds) are fine
set swapfile
set directory^=~/.vim/swap//

" protect against crash-during-write
set writebackup
" but do not persist backup after successful write
set nobackup
" use rename-and-write-new method whenever safe
set backupcopy=auto
" patch required to honor double slash at end
set backupdir^=~/.vim/backup//
" persist the undo tree for each file
set undofile
set undodir^=~/.vim/undo//
set cmdheight=1
set updatetime=300
set signcolumn=yes
set listchars=tab:>-,trail:~,extends:>,precedes:<,nbsp:-
set list
set number
set nospell
set hlsearch
set ignorecase smartcase
set encoding=utf-8
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set copyindent
set autoindent
set cursorline
set cursorcolumn
set shortmess+=cfilmnrxoOtT
set showmatch
set showmode
set showcmd
set clipboard+=unnamedplus
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
    \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
    \,sm:block-blinkwait175-blinkoff150-blinkon175

imap <C-c> <ESC>
" 空格键向上滚屏 光标不变
nnoremap <SPACE> 2<C-e>
noremap <C-j> 3<C-e>
noremap <C-k> 3<C-y>

" ctrl+h l 分别在插入模式下左右移动
imap <C-h> <ESC>i
imap <C-l> <ESC>la

" make tab do tabs at beginning and spaces elsewhere
function RetabIndents()
  let l:saved_view = winsaveview()
  silent! %s/\t/\=repeat(" ", &tabstop)/
  call winrestview(l:saved_view)
endfunction

" http://vim.wikia.com/wiki/Remove_unwanted_spaces
function StripTrailingWhite()
  let l:winview = winsaveview()
  silent! %s/\s\+$//
  call winrestview(l:winview)
endfunction

autocmd BufWritePre,FileAppendPre,FileWritePre,FilterWritePre * :call StripTrailingWhite()
" autocmd BufWritePre,FileAppendPre,FileWritePre,FilterWritePre * :call RetabIndents()

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set rnu
    autocmd BufLeave,FocusLost,InsertEnter   * set nornu
augroup END

call plug#begin(stdpath('data') . '/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'preservim/nerdcommenter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'Chiel92/vim-autoformat'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Raimondi/delimitMate'
Plug 'wakatime/vim-wakatime'
call plug#end()
let g:NERDSpaceDelims=1
let g:python3_host_prog = '/home/artin/miniconda3/bin/python'
let g:UltiSnipsExpandTrigger="<c-u><c-n>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

map <C-b> :NERDTreeToggle<CR>

set termguicolors
colorscheme dracula

map  <silent> <S-Insert> "+p
imap <silent> <S-Insert> <Esc>"+pa

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
au CursorHoldI * sil call CocActionAsync('showSignatureHelp')

command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold   :call CocAction('fold', <f-args>)
command! -nargs=0 OR     :call CocAction('runCommand', 'editor.action.organizeImport')

au BufRead,BufNewFile *.cpp,*.c nnoremap <F5>   <Esc>:w<CR>:!g++ -std=c++11 % -o /tmp/a.out && /tmp/a.out<CR>
au BufRead,BufNewFile *.cpp,*.c nnoremap <F7>   <Esc>:w<CR>:!g++ -std=c++11 %<CR>
au BufRead,BufNewFile *.cpp,*.c nnoremap <C-F5> <Esc>:w<CR>:!g++ -std=c++11 -g % -o /tmp/a.out && gdb /tmp/a.out<CR>
au BufRead,BufNewFile *.py nnoremap <F5> <Esc>:w<CR>:!python %<CR>
au BufRead,BufNewFile *.rs nnoremap <F5> <Esc>:w<CR>:!cargo run %<CR>

" for C-like  programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c,cpp,java set formatoptions+=ro

" fixed indentation should be OK for XML and CSS. People have fast internet
" anyway. Indentation set to 2.
autocmd FileType html,xhtml,css,xml,xslt set shiftwidth=2 softtabstop=2

" two space indentation for some files
autocmd FileType vim,lua,nginx set shiftwidth=2 softtabstop=2

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

" ensure normal tabs in assembly files
" and set to NASM syntax highlighting
autocmd FileType asm set noexpandtab shiftwidth=8 softtabstop=0 syntax=nasm
