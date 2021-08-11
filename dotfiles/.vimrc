"=====================================================
" Plugins
"=====================================================

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
Plug 'python-mode/python-mode', { 'branch': 'develop' }
Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'} 
Plug 'rosenfeld/conque-term'
Plug 'kien/ctrlp.vim'
Plug 'mitsuhiko/vim-jinja'

"colorschemes
Plug 'tomasr/molokai'
call plug#end()

filetype on
filetype plugin on

"=====================================================
" General settings
"=====================================================

set clipboard=unnamedplus

"setting colorscheme
let g:molokai_original = 1 
color molokai

"mappings
map <C-n> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>

"sets and options
set showtabline=2
set number
set hlsearch
set incsearch

set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf8,koi8r,cp1251,cp866,ucs-2le

set cursorline
syntax on
set mouse=a
set laststatus=2
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0 

let g:ctrlp_user_command = 'find %s -type f ! -path "*/.git/*" ! -path "*.swp" ! -path "*.so" 2>&/dev/null'

let g:tagbar_autofocus = 0

let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let NERDTreeIgnore=['\~$', '\.pyc$', '\.pyo$', '\.class$', 'pip-log\.txt$', '\.o$']

"closing vim if opened only NURDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"disabling doc
let g:pymode_doc = 0

"python lint
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
let g:pymode_lint_ignore="E501,W601,C0110"
"lint after write
let g:pymode_lint_write = 1

"virtualenv
let g:pymode_virtualenv = 1

"breakpoints
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = '<leader>b'

"syntax highlight
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

"code run
let g:pymode_run = 0

"debug-mode <F5>
autocmd Filetype python nnoremap <F5> :exec "!python3 ".append("%")<CR>
autocmd Filetype cpp nnoremap <F5> :make!<cr>
autocmd Filetype c nnoremap <F5> :make!<cr>

let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_CloseOnEnd = 0
"PEP8 <leader>8
autocmd FileType python map <buffer> <leader>8 :PymodeLint<CR>

" --- JavaScript ---
let javascript_enable_domhtmlcss=1
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd BufNewFile,BufRead *.json setlocal ft=javascript

" --- HTML ---
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd bufnewfile,bufread *.rhtml setlocal ft=eruby
autocmd BufNewFile,BufRead *.mako setlocal ft=mako
autocmd BufNewFile,BufRead *.tmpl setlocal ft=htmljinja
autocmd BufNewFile,BufRead *.py_tmpl setlocal ft=python
let html_no_rendering=1
let g:closetag_default_xml=1
let g:sparkupNextMapping='<c-l>'

" --- CSS ---
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
