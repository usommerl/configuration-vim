""" plugins
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
filetype plugin on
filetype indent on
syntax on

runtime macros/matchit.vim

""" options
set nocompatible
set spelllang=de             " spell language
set dir=~/.vim/swp           " unified location of swap files
set viminfo+=n~/.vim/viminfo " location of the viminfo file
set ignorecase
set smartcase
set hidden
set t_Co=256
set history=1000
set autoread
set linebreak
set backspace=2
set number
set laststatus=2
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set hlsearch
set incsearch
set foldcolumn=1
set foldtext=MyFoldText()
set foldmethod=syntax
set foldlevelstart=99
set wildmenu
set showcmd
set complete=.,w,b,u,U,t,i,d,k
set dictionary=/usr/share/dict/ngerman,/usr/share/dict/british-english 
set listchars=tab:>-,eol:$,nbsp:%
"set pdev=pdf
"set printoptions=paper:A4,syntax:y,wrap:y,duplex:long

""" custom functions
function! MyFoldText()
    let line = getline(v:foldstart)
    let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
    return v:folddashes . sub
endfunction

function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

""" keys
let mapleader = ","

"when using vim as mergetool
map <silent> <leader>2 :diffget 2<CR> :diffupdate<CR>
map <silent> <leader>3 :diffget 3<CR> :diffupdate<CR>
map <silent> <leader>4 :diffget 4<CR> :diffupdate<CR>

"stop using arrow keys
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
vnoremap  <Up>     <NOP>
vnoremap  <Down>   <NOP>
vnoremap  <Left>   <NOP>
vnoremap  <Right>  <NOP>

"move curser on display lines not actual lines
nnoremap j gj
nnoremap k gk

"map keys to move lines
noremap <C-j> :m+<cr>==
noremap <C-k> :m-2<cr>==
inoremap <C-j> <Esc>:m+<cr>==gi
inoremap <C-k> <Esc>:m-2<cr>==gi
vnoremap <C-j> :m'>+<CR>gv=gv
vnoremap <C-k> :m-2<CR>gv=gv

"quickfix list
map <F4> :call ToggleList("Quickfix List", 'c')<cr>
imap <F4> :call ToggleList("Quickfix List", 'c')<cr>

"tab in insert mode
imap <S-Tab> 

"update buffer
map <F5> :update<cr>
imap <F5> <c-o>:update<cr>

"quit
map <F12> :q<cr>
imap <F12> <c-o>:q<cr>

"bufexplorer
map <F8> :BufExplorer<cr>
imap <F8> <Esc>:BufExplorer<cr>
vmap <F8> :BufExplorer<cr>

"map keys to copy lines
"TODO do i need this anymore?
map <C-M-Up> yyP
map <S-M-Down> yyp
imap <S-M-Up> <Esc>yyPgi<up>
imap <S-M-Down> <Esc>yypgi<down>
vmap <S-M-Up> <Esc>:'<,'>copy'<-<cr>
vmap <S-M-Down> <Esc>:'<,'>copy'><cr>

"easy expansion of the active file directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

"mute highlighting
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

""" colors
let file=expand("~/.vim/colorscheme")
if filereadable(file)
   " read colorscheme setting from external file if it exists
   exe "source " . file
else
   " default colorscheme
   colorscheme lucius
   LuciusDark
endif

""" statusline
set statusline=[%n]\                             " buffer number
set statusline+=%<                               " truncate from here if line is too long
set statusline+=%F                               " filename
set statusline+=%m%r%h%w\                        " flags
set statusline+=%=                               " shove everything from here to the right
set statusline+=[%{strlen(&fenc)?&fenc:&enc}]\   " encoding
set statusline+=%{strlen(&ft)?'['.&ft.']\ ':''}  " filetype
set statusline+=[%l,%v]\                         " position in file [line,column]
set statusline+=[%p%%]                           " percentage

""" autocommands
au! bufwritepost .vimrc source ~/.vimrc
au! Filetype tex,asciidoc,sh set foldmethod=manual
au! BufReadCmd *.odt,*.ott,*.ods,*.ots,*.odp,*.otp,*.odg,*.otg call zip#Browse(expand("<amatch>"))
au! BufWinLeave *.* mkview
au! BufWinEnter *.* silent loadview 



