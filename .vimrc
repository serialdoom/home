set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}
Plugin 'git@github.com:vim-scripts/DirDiff.vim.git'
Plugin 'git@github.com:mileszs/ack.vim.git'
Plugin 'git@github.com:serialdoom/comments.vim.git'
Plugin 'git@github.com:kien/ctrlp.vim.git'
Plugin 'git@github.com:serialdoom/savevers.vim.git'
Plugin 'git@github.com:MarcWeber/vim-addon-mw-utils.git'
Plugin 'git@github.com:tomtom/tlib_vim.git'
Plugin 'git@github.com:serialdoom/vim-snipmate.git'
Plugin 'git@github.com:serialdoom/vcscommand.vim.git'
Plugin 'git@github.com:serialdoom/VisIncr.git'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"  Instal all with
"  	vim +PluginInstall +qall
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let mapleader = ","
set t_Co=256
set bg=dark
set hidden
set ff=unix
set showmatch
set ignorecase
set nocompatible
set nowrap
set history=9999
imap jj <esc>
set modeline
set ls=2
" center the window 
set so=999
set sw=4
set incsearch
set modeline
set viminfo='10,\"100,:20,%,n~/.viminfo " what to save for each file
set wrap " wrap the damn lines
set lbr "wrap at character
" set your on line break charactesr
set breakat=\ ,(*;+=/|
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
" backspace now moves to previous line 
set backspace=indent,eol,start
set hlsearch
" when pressing enter, use the last good indent level
set autoindent
"enable syntax.. Doh
syntax enable
set backup 
set patchmode=.clean 
" where jesus saves.
let savevers_dirs=".backup/vim/"
set wildignore +=*.d,*.o,*.dox,*.a,*.clean,*.bin,*.elf,*.i,*.back
set rnu
set expandtab "use spaces instead of tabs
set tabstop=4
set shiftwidth=4
let g:netrw_sort_sequence = '[\/]$,\<core\%(\.\d\+\)\=\>,\.h$,\.c$,\.cpp$,\~\=\*$,*,\.o$,\.obj$,\.info$,\.swp$,\.bak$,\.clean$,\.rej,\.orig,\~$'

set cursorline
set cursorcolumn
hi CursorLine   cterm=NONE ctermbg=232 guibg=#050505
hi CursorColumn cterm=NONE ctermbg=232 guibg=#050505
hi Folded ctermbg=234 ctermfg=red
hi ColorColumn ctermbg=233
hi Search ctermbg=134 ctermfg=0

nmap ed :e %:h<cr>
nmap <Space> <PageDown>
nmap <leader>pe :!p4 edit %<cr>
map :! q:?

autocmd WinEnter * setlocal cursorline
autocmd WinEnter * setlocal cursorcolumn
autocmd WinEnter * setlocal cc=80
autocmd WinLeave * setlocal nocursorline
autocmd WinLeave * setlocal nocursorcolumn
autocmd WinLeave * setlocal cc=0
autocmd VimLeave * :call SessionCreate()
autocmd BufWritePre * :if &readonly | !p4 edit %

nmap <silent> <c-h> :VersDiff -<cr> 
nmap <silent> <c-j> :VersDiff +<cr> 
nmap <silent> <c-k> :VersDiff -cvs<cr> 
nmap <silent> <c-l> :VersDiff -c<cr>

set runtimepath^=~/.vim/bundle/ctrlp.vim
map <leader>t :CtrlP<cr>
map <leader>b :CtrlPBuffer<cr>
let g:ctrlp_map = '<c-g>'

let g:ackprg = 'ag --nogroup --nocolor --column'
nmap _a :Ack! <cword><cr>
nmap _c :Ack! --cc <cword><cr>
nmap _x :Ack! --xml <cword><cr>
nmap _C :Ack! --cc --xml <cword><cr>
nmap _M :Ack! --make <cword><cr>

let g:VCSCommandDeleteOnHide=66
let g:CommandTMaxCachedDirectories=0
let VCSCommandVCSTypePreference='hg'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("user_commands")
    command! -bang -nargs=? -complete=file E e<bang> <args>
    command! -bang -nargs=? Cs cs<bang> <args>
    command! -bang -nargs=? -complete=file W w<bang> <args>
    command! -bang -nargs=? -complete=file Wq wq<bang> <args>
    command! -bang -nargs=? -complete=file WQ wq<bang> <args>
    command! -bang -nargs=? -complete=file Set set<bang> <args>
    " map the damn :W so that you dont type it twice. Or even 3 times. Fucking noob.
    command! -bang Wqa wqa<bang>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
    command! -bang Set set<bang>
endif


" fill rest of line with characters
function! FillLine( str )
    " set tw to the desired total length
    let tw = &textwidth
    if tw==0 | let tw = 80 | endif
    " strip trailing spaces first
    .s/[[:space:]]*$//
    " calculate total number of 'str's to insert
    let reps = (tw - col("$")) / len(a:str)
    " insert them, if there's room, removing trailing spaces (though forcing
    " there to be one)
    if reps > 0
        .s/$/\=(' '.repeat(a:str, reps))/
    endif
endfunction

nmap \f- :call FillLine("-")<cr>
nmap \f* :call FillLine("*")<cr>

function! SessionCreate()
    let r_name = $HOME . "/.vim_sessions/" . substitute(getcwd(), "\/", "_", "g") . ".vim"
    exe "mksession! " . r_name
endfunction

function! SessionRestore()
    let r_name = $HOME . "/.vim_sessions/" . substitute(getcwd(), "\/", "_", "g") . ".vim"
    exe "source " . r_name
endfunction
command! -nargs=* RS call RestoreSession()

"
" Wrap visual selection in an #if 0/#endif tag.
vmap <Leader>if <Esc>:call VisualHTMLTagWrap()<CR>
function! VisualHTMLTagWrap()
  let tag = "#if 0"
  if len(tag) > 0
    normal `>
    if &selection == 'exclusive'
      exe "normal i\n#endif"
    else
      exe "normal a\n#endif"
    endif
    normal `<
    exe "normal i#if 0\n"
    normal `<
    exe ":'<,'>+1normal =="
  endif
endfunction

"
" Reverse the lines of the whole file or a visually highlighted block.
" :Rev is a shorter prefix you can use.
" Adapted from http://tech.groups.yahoo.com/group/vim/message/34305
command! -nargs=0 -bar -range=% Reverse
\       let save_mark_t = getpos("'t")
\<bar>      <line2>kt
\<bar>      exe "<line1>,<line2>g/^/m't"
\<bar>  call setpos("'t", save_mark_t)


nmap <leader>o :call FunctionCommentOut()<cr>
function! FunctionCommentOut()
    exe "normal! ?^{\n"
    exe "normal j"
    exe "normal V"
    exe "normal k"
    exe "normal %"
    exe "normal k"
    exe "normal ,if"
endfunction
