" convinience
syntax on
set smartindent
set encoding=utf8
set paste
set ruler
set showcmd


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") < line("$") |
    \   exe "normal g`\"" |
    \ endif

endif " has("autocmd")

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" Fix pro ctrl a sipku
nnoremap <ESC>[1;5D <C-Left>
nnoremap <ESC>[1;5C <C-Right>

map! <ESC>[1;5D <C-Left>
map! <ESC>[1;5C <C-Right>


" saves cursor history
set viminfo='10,\"100,:20,%,n~/.viminfo
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" hilight search
set hlsearch

" psp syntax
au BufNewFile,BufRead *.psp set filetype=psp
" jinja syntax
au BufNewFile,BufRead *.tmpl set filetype=htmljinja
" proto syntax
au BufNewFile,BufRead *.proto set filetype=proto

" line endings
autocmd BufRead,BufNewFile * syntax match Error "\s\+$"

" tabulators
set tabstop=4
set shiftwidth=4
set expandtab

au BufNewFile,BufReadPre *.py set shiftwidth=4
au BufNewFile,BufReadPre *.py set tabstop=4
au BufNewFile,BufReadPre *.sh set shiftwidth=2
au BufNewFile,BufReadPre *.java set shiftwidth=2
augroup filetypedetect
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
augroup END

" taby
map <C-Insert> :tabnew<CR>
" nmap <C-Delete> :tabclose<CR>
map tn :tabnew<CR>
map td :tabclose<CR>
noremap <C-E> :tabnext<CR>
noremap <C-W> :tabprevious<CR>

" podpora toggle comment
map <C-C> :TC <CR>j
imap <C-C> <ESC>:TC <CR>j

" backups
set nobackup
set nowritebackup
set noswapfile

" paste mode
noremap <F1> :set invpaste paste?<CR>
set pastetoggle=<F1>
set showmode
au InsertLeave * set nopaste

" backspace through everything in INSERT mode
set backspace=indent,eol,start

" start scrolling three lines before the horizontal window border
set scrolloff=3

" remamps double collon
nnoremap ; :

" line by visual line movement
nnoremap j gj
nnoremap k gk

" escape remaping
inoremap jk <Esc>

" start / endline remap
noremap H ^
noremap L $

" use system keyboard
set clipboard=unnamed

" file tabs
if has("wildmenu")
    set wildmenu
    set wildmode=longest,list
endif
