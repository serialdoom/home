set nocompatible              " be iMproved, required
filetype off                  " required

" initial checkout
"    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim.git'

Plugin 'vim-scripts/DirDiff.vim.git'
Plugin 'mileszs/ack.vim.git'
Plugin 'serialdoom/comments.vim.git'
Plugin 'tpope/vim-fugitive'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'
Plugin 'MarcWeber/vim-addon-mw-utils.git'
Plugin 'tomtom/tlib_vim.git'
Plugin 'serialdoom/vim-snipmate.git'
Plugin 'serialdoom/vcscommand.vim.git'
Plugin 'serialdoom/VisIncr.git'
Plugin 'serialdoom/vim-ansible-yaml.git'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'serialdoom/vim-template.git'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'vim-syntastic/syntastic.git'
Plugin 'tomasr/molokai.git'
Plugin 'hashivim/vim-terraform.git'
Plugin 'tpope/vim-commentary.git'
Plugin 'tpope/vim-surround'

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

let s:uname = system("uname -s")
if has('nvim')
    set mouse=r
endif

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
inoremap jk <esc>
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
set modeline
set ls=2
set so=999 " center the window
set sw=4
set incsearch
set modeline
set viminfo='10,\"100,:20,% " what to save for each file
set wrap " wrap the damn lines
set lbr "wrap at character
set breakat=\ ,(*;+=/| " set your on line break charactesr
set statusline=%{fugitive#statusline()}%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set backspace=indent,eol,start " backspace now moves to previous line 
set hlsearch
set autoindent
syntax enable
set wildignore +=*.d,*.o,*.dox,*.a,*.clean,*.bin,*.elf,*.i,*.back
set expandtab "use spaces instead of tabs
set tabstop=4
set shiftwidth=4
set clipboard=unnamed
let g:netrw_sort_sequence = '[\/]$,\<core\%(\.\d\+\)\=\>,\.h$,\.c$,\.cpp$,\~\=\*$,*,\.o$,\.obj$,\.info$,\.swp$,\.bak$,\.clean$,\.rej,\.orig,\~$'

colorscheme molokai
set cursorline
set cursorcolumn
hi CursorLine   cterm=NONE ctermbg=232 guibg=#050505
hi CursorColumn cterm=NONE ctermbg=232 guibg=#050505
hi Folded ctermbg=234 ctermfg=red
hi ColorColumn ctermbg=233
hi Search ctermbg=134 ctermfg=0

nmap ed :e %:h<cr>
nmap <Space> <PageDown>

if has("autocmd")
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    autocmd WinEnter * setlocal cursorline
    autocmd WinEnter * setlocal cursorcolumn
    autocmd WinEnter * setlocal cc=80
    autocmd WinLeave * setlocal nocursorline
    autocmd WinLeave * setlocal nocursorcolumn
    autocmd WinLeave * setlocal cc=0
    autocmd VimLeave * :call SessionCreate()
    autocmd FileType python :set makeprg=pep8\ %
    autocmd BufReadPost,WinEnter *.py :set makeprg=pep8\ %
    autocmd BufEnter *.mkf :set ft=make
    autocmd BufEnter *.dsl :set ft=groovy
    autocmd BufEnter *.yml :set ft=ansible
    autocmd BufEnter Vagrantfile :set ft=ruby
    autocmd WinLeave * :setlocal rnu!
    autocmd WinEnter * :setlocal rnu


endif

if s:uname == "Darwin\n"
    map `t :FZF<cr>
    map `r :History:<cr>
    map `b :Buffers<cr>
    map `a :Ag<cr>
    map `e :GBrowse<cr>
endif

let g:ackprg = 'ag --skip-vcs-ignores --nogroup --nocolor --column'
nmap _a :Ack! <cword><cr>
nmap _c :Ack! --cc <cword><cr>
nmap _x :Ack! --xml <cword><cr>
nmap _C :Ack! --cc --xml <cword><cr>
nmap _M :Ack! --make <cword><cr>
nmap _p :Ack! --python <cword><cr>

nmap + :ts <C-R>=expand("<cword>")<cr><cr>

let g:VCSCommandDeleteOnHide=66
let g:CommandTMaxCachedDirectories=0
let VCSCommandVCSTypePreference='git'
let g:DirDiffExcludes = "*.pyc"

nmap <leader>n :cnext<cr>
nmap <leader>m :cprev<cr>


set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8', 'pylint']

" hide vim swap files from the file browser
let g:netrw_list_hide= '.*\.swp$,\~$,\.orig$'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("user_commands")
    command! -bang -nargs=? -complete=file E e<bang> <args>
    command! -bang -nargs=? Cs cs<bang> <args>
    command! -bang -nargs=? -complete=file W w<bang> <args>
    command! -bang -nargs=? -complete=file Wq wq<bang> <args>
    command! -bang -nargs=? -complete=file WQ wq<bang> <args>
    cabbrev Set set
    cabbrev ack Ack
    cabbrev acl Ack
    cabbrev passgen PassGen 
    " map the damn :W so that you dont type it twice. Or even 3 times. Fucking noob.
    command! -bang Wqa wqa<bang>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
    command! -bang Set set<bang>
    command! -bang Vs vs<bang>
endif

function! SessionCreate()
    let r_name = $HOME . "/.vim_sessions/" . substitute(getcwd(), "\/", "_", "g") . ".vim"
    exe "mksession! " . r_name
endfunction

function! SessionRestore()
    let r_name = $HOME . "/.vim_sessions/" . substitute(getcwd(), "\/", "_", "g") . ".vim"
    exe "source " . r_name
endfunction
command! -nargs=* RS call SessionRestore()

