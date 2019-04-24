" use pyenv pythons
let g:python_host_prog = expand('~/.pyenv/versions/neovim2/bin/python')
let g:python3_host_prog = expand('~/.pyenv/versions/neovim3/bin/python')

call plug#begin()

" appearance
Plug 'rkernan/vim-modestatus'
Plug 'morhetz/gruvbox'
" searching
Plug 'haya14busa/vim-asterisk'
" text object
Plug 'wellle/targets.vim'
" vcs integration
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
" fzf integration
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-bash' }
Plug 'junegunn/fzf.vim'
" other
Plug 'editorconfig/editorconfig-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
" completion - engine
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2'
" completion - sources
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
" searching
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'

call plug#end()

set background=dark
try
	colorscheme gruvbox
endtry

let mapleader="\<space>"

set undofile

set ttimeout
set ttimeoutlen=100

set ignorecase
set smartcase

set fillchars=
set listchars=eol:¬,tab:»\ ,trail:·

set clipboard+=unnamedplus

set wildmode=longest:full,full
set wildignore+=.hg,.git,.svn                    " version control files
set wildignore+=*.aux,*.out,*.toc                " LaTeX build files
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.class                          " java compiled objects
set wildignore+=*.luac                           " lua byte code
set wildignore+=*.pyc                            " python byte code
set wildignore+=*.sw                             " vim swap files
set wildignore+=*.DS_Store                       " OSX something

set scrolloff=1
set sidescrolloff=3

set hidden
set shortmess=actWIF
set lazyredraw
set splitbelow
set splitright

set signcolumn=yes
set noshowmode

set cursorline
" auto-enable based on window focus
autocmd BufEnter,FocusGained * setlocal number cursorline
autocmd BufLeave,FocusLost   * setlocal number nocursorline

set number
set relativenumber
" auto-switch to/from relative line numbers based on mode
autocmd InsertLeave * setlocal relativenumber
autocmd InsertEnter * setlocal norelativenumber
" auto-switch to/from relative line numbers based on window focus
autocmd BufEnter,FocusGained * setlocal number relativenumber
autocmd BufLeave,FocusLost * setlocal number norelativenumber

" restore line position on restart
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" resize windows automatically
autocmd VimResized * wincmd =

set mouse=a

" disable ex mode
nnoremap Q <nop>

" yank to end of line
nnoremap Y y$

" treat line wraps as real lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" indent and un-indent
vnoremap > >gv
vnoremap < <gv

" visually select last edited/pasted text
nnoremap gV `[v`]

" automatically jump to the end of the last paste
vnoremap y y`]
vnoremap p p`]
nnoremap p p`]

" execute macro over visual range
function! s:execute_macro_over_visual_range()
	echo "@".getcmdline()
	execute ":'<,'> normal @" . nr2char(getchar())
endfunction
xnoremap @ :<C-u>call <SID>execute_macro_over_visual_range()<CR>

" Plugin - Auto-pairs
autocmd FileType vim let b:AutoPairs = {'(': ')', '[': ']', '{': '}', "'": "'", '`': '`'}

" Plug - FZF
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>f :Files<cr>
" use floating 
let $FZF_DEFAULT_COMMAND="find -L -type f"
let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': 'call float_fzf#open()' }
let g:float_fzf_width = 120
let g:float_fzf_pad_side = 4
let g:float_fzf_pad_bottom = 3

" Plugin - Incsearch, Incsearch-Fuzzy, Asterisk
" don't break basic search if plugin is not installed
noremap <Plug>(incsearch-forward) /
noremap <Plug>(incsearch-backward) ?
noremap <Plug>(incsearch-nohl-n) n
noremap <Plug>(incsearch-nohl-N) N
noremap <Plug>(incsearch-nohl) <nop>
" replace search
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
" auto nohlsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n <Plug>(incsearch-nohl-n)
map N <Plug>(incsearch-nohl-N)
map * <Plug>(incsearch-nohl)<Plug>(asterisk-*)
map g* <Plug>(incsearch-nohl)<Plug>(asterisk-g*)
map # <Plug>(incsearch-nohl)<Plug>(asterisk-#)
map g# <Plug>(incsearch-nohl)<Plug>(asterisk-g#)
map z* <Plug>(incsearch-nohl0)<Plug>(asterisk-z*)
map gz* <Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)
map z# <Plug>(incsearch-nohl0)<Plug>(asterisk-z#)
map gz# <Plug>(incsearch-nohl0)<Plug>(asterisk-gz#)
" auto nohlsearch in substitute
noremap <Plug>(my_:) :
map <buffer> : <Plug>(incsearch-nohl)<Plug>(my_:)
" fuzzy search
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)

" Plugin - Modestatus
let g:modestatus#statusline = [
	\		['mode'],
	\		['fugitive_branch', 'signify_added', 'signify_modified', 'signify_removed'],
	\		'filename', 'modified', 'readonly', 'filetype',
	\		'%=',
	\		'expandtab', 'shiftwidth', 'encoding', 'bomb', 'fileformat',
	\		['line', 'column', 'line_percent']
	\	]
let g:modestatus#statusline_override_fugitiveblame = ['filetype', '%=', ['line', 'line_max', 'line_percent']]
let g:modestatus#statusline_override_qf = [['mode'], 'buftype', 'filetype', '%=', ['line', 'line_max', 'line_percent']]
" overrides
autocmd FileType fugitiveblame silent! call modestatus#setlocal('fugitiveblame')
autocmd FileType qf silent! call modestatus#setlocal('qf')
" settings
silent! call modestatus#options#add('mode', 'color', 'ModestatusMode')
silent! call modestatus#options#add('fugitive_branch', 'color', ['Modestatus2', 'Modestatus2NC'])
silent! call modestatus#options#add('signify_added', 'color', ['Modestatus2Green', 'Modestatus2NCGreen'])
silent! call modestatus#options#add('signify_modified', 'color', ['Modestatus2Aqua', 'Modestatus2NCAqua'])
silent! call modestatus#options#add('signify_removed', 'color', ['Modestatus2Red', 'Modestatus2NCRed'])
silent! call modestatus#options#add('filename', 'color', ['ModestatusBold', 'ModestatusNC'])
silent! call modestatus#options#add('modified', 'color', ['ModestatusRedBold', 'ModestatusNCRedBold'])
silent! call modestatus#options#add('readonly', 'color', ['ModestatusRed', 'ModestatusNCRed'])
silent! call modestatus#options#add('expandtab', 'format', '[%s')
silent! call modestatus#options#add('shiftwidth', 'format', '%s]')
silent! call modestatus#options#add('encoding', 'format', '[%s')
silent! call modestatus#options#add('encoding', 'separator', '')
silent! call modestatus#options#add('bomb', 'format', '-%s')
silent! call modestatus#options#add('bomb', 'separator', '')
silent! call modestatus#options#add('fileformat', 'format', ':%s]')
silent! call modestatus#options#add('line', 'color', ['Modestatus2', 'Modestatus2NC'])
silent! call modestatus#options#add('line', 'separator', '')
silent! call modestatus#options#add('column', 'format', ',%s')
silent! call modestatus#options#add('column', 'color', ['Modestatus2', 'Modestatus2NC'])
silent! call modestatus#options#add('line_max', 'format', '/%s')
silent! call modestatus#options#add('line_max', 'color', ['Modestatus2', 'Modestatus2NC'])
silent! call modestatus#options#add('line_percent', 'color', ['Modestatus2', 'Modestatus2NC'])

" Plugin - LanguageClient
let g:LanguageClient_serverCommands = {
	\		'javascript': ['javascript-typescript-stdio'],
	\		'go': ['bingo'],
	\		'python': ['~/.pyenv/versions/pyls/bin/pyls'],
	\		'rust': ['rustup', 'run', 'stable', 'rls'],
	\	}
nnoremap <leader>c :call LanguageClient_contextMenu()<cr>

" Plug - NCM2
set completeopt=noinsert,menuone,noselect
autocmd BufEnter * call ncm2#enable_for_buffer()
let g:ncm2#matcher = 'substrfuzzy'
inoremap <C-c> <Esc>
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Plugin - Signify
let g:signify_sign_change = '~'
let g:signify_sign_delete = '-'

" Plugin - Targets
let g:targets_pairs = '() {} [] <>'
let g:targets_argTrigger = ','
let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'
