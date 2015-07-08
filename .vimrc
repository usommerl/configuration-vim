" {{{ Plugins
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
Helptags " generate vim help for plugins
filetype plugin on
filetype indent on
syntax on

runtime macros/matchit.vim

" {{{ Syntastic
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['scala'] }
" }}}

" {{{ Unite
if executable('ack')
  let g:unite_source_grep_command = 'ack'
elseif executable('ack-grep')
  let g:unite_source_grep_command = 'ack-grep'
endif

let g:unite_source_history_yank_enable = 1
let g:unite_split_rule = "botright"
let g:unite_source_grep_recursive_opt = ''
let g:unite_source_grep_default_opts = '--no-heading --no-color'
let g:unite_source_session_enable_auto_save = 1
let g:unite_source_find_default_expr = '-iname '

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#source('buffer', 'sorters', 'sorter_word')
call unite#custom#source('session', 'sorters', 'sorter_word')
call unite#custom#source('find', 'max_candidates', 0)
call unite#custom#source('grep', 'max_candidates', 0)
" }}}

" }}}

" {{{ General options
set encoding=utf-8
set nocompatible
set spelllang=de
set dir=~/.vim/swp           " unified location of swap files
set undofile
set undodir=~/.vim/undo
set undolevels=1000
set undoreload=10000
set history=1000
set viminfo+=n~/.vim/viminfo
set ignorecase
set smartcase
set hidden
set t_Co=256
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
set listchars=tab:▸\ ,eol:$,nbsp:%
set cursorline

let g:xml_syntax_folding=1
" }}}

" {{{ Functions
function! MyFoldText()
    let line = getline(v:foldstart)
    let sub = substitute(line, '.*{\{3}\s*', ' ', 'g')
    return v:folddashes . sub . ' '
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
" }}}

" {{{ Keys
let mapleader = ","

"when using vim as mergetool
map <silent> <leader>1 :diffget 1<CR> :diffupdate<CR>
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
vnoremap <C-j> :m'>+<CR>gv=gv
vnoremap <C-k> :m-2<CR>gv=gv

"quickfix list
map <F4> :call ToggleList("Quickfix List", 'c')<cr>
imap <F4> :call ToggleList("Quickfix List", 'c')<cr>

"tab in insert mode
imap <S-Tab> 

"capitalize text (source: http://goo.gl/Grhx9f)
if (&tildeop)
  nmap gcw guw~l
  nmap gcW guW~l
  nmap gciw guiw~l
  nmap gciW guiW~l
  nmap gcis guis~l
  nmap gc$ gu$~l
  nmap gcgc guu~l
  nmap gcc guu~l
  vmap gc gu~l
else
  nmap gcw guw~h
  nmap gcW guW~h
  nmap gciw guiw~h
  nmap gciW guiW~h
  nmap gcis guis~h
  nmap gc$ gu$~h
  nmap gcgc guu~h
  nmap gcc guu~h
  vmap gc gu~h
endif

"toggle display of non-visible characters
nnoremap <leader>l :set list!<CR>

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
"always map E command to Explore
command! -nargs=* -bar -bang -count=0 -complete=dir E Explore <args>

"mute highlighting
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

"yank file or directory name
nnoremap <silent> <leader>yf :<C-u>let @+ = expand("%:p") <cr>
nnoremap <silent> <leader>yd :<C-u>let @+ = expand("%:p:h")<cr>

" unite keys
nnoremap <silent> <leader>o :<C-u>Unite -buffer-name=outline -vertical outline<cr>
nnoremap <silent> <leader>b :<C-u>Unite -buffer-name=buffers buffer<cr>
nnoremap <silent> <leader>g :<C-u>Unite -buffer-name=grep grep<cr>
nnoremap <silent> <leader>f :<C-u>Unite -buffer-name=find find<cr>
nnoremap <silent> <leader>yh :<C-u>Unite -buffer-name=yanks history/yank<cr>
nnoremap <silent> <leader>rg :<C-u>UniteResume grep<cr>
nnoremap <silent> <leader>rf :<C-u>UniteResume find<cr>
nnoremap <silent> <leader>so :<C-u>Unite -buffer-name=sessions session<cr>
nnoremap <silent> <leader>ss :<C-u>UniteSessionSave<cr>
nnoremap <silent> <leader>sn :<C-u>Unite -buffer-name=sessions -start-insert session/new<cr>
nnoremap <silent> <leader>sc :<C-u>echo v:this_session<cr>
nnoremap <leader>ugo :<C-u>Unite -buffer-name=grep grep:.:
" }}}

" {{{ Colors
let file=expand("~/.vim/colorscheme")
if filereadable(file)
   " read colorscheme setting from external file if it exists
   exe "source " . file
else
   " default colorscheme
   colorscheme lucius
   LuciusDark
endif
" }}}

" {{{ Statusline
set statusline=[%n]\                             " buffer number
set statusline+=%<                               " truncate from here if line is too long
set statusline+=%F                               " filename
set statusline+=%m%r%h%w\                        " flags
set statusline+=%=                               " shove everything from here to the right
set statusline+=[%{strlen(&fenc)?&fenc:&enc}]\   " encoding
set statusline+=%{strlen(&ft)?'['.&ft.']\ ':''}  " filetype
set statusline+=[%l,%v]\                         " position in file [line,column]
set statusline+=[%p%%]                           " percentage
" }}}

" {{{ Autocommands
au! BufWritePost .vimrc source ~/.vimrc | setlocal foldmethod=marker
au! Filetype tex,asciidoc,sh setlocal foldmethod=manual
au! BufReadCmd *.odt,*.ott,*.ods,*.ots,*.odp,*.otp,*.odg,*.otg call zip#Browse(expand("<amatch>"))
au! BufWinLeave *.* setlocal backupcopy=auto|mkview
au! BufWinEnter *.* silent loadview 
au! Filetype ruby
            \ let &l:colorcolumn=join(range(81,999),",") |
            \ setlocal regexpengine=1 foldmethod=manual ts=2 sw=2 sts=2 expandtab
" }}}
