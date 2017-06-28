call plug#begin()

" appearance
Plug 'rkernan/vim-modestatus'
Plug 'morhetz/gruvbox'
" languages
Plug 'sheerun/vim-polyglot'
" syntax checking
Plug 'w0rp/ale'
" code completion
Plug 'shougo/neocomplete.vim'
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'ternjs/tern_for_vim', {'do': 'npm install', 'for': 'javascript'}
" vcs integration
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
" searching
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/vim-asterisk'
" text objects
Plug 'kana/vim-textobj-user' " dependency
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'wellle/targets.vim'
" other
Plug 'jiangmiao/auto-pairs'
Plug 'mbbill/undotree', {'on': ['UndotreeFocus', 'UndotreeHide', 'UndotreeShow', 'UndotreeToggle']}
Plug 'shougo/denite.nvim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

call plug#end()

" clear autocmd
augroup vimrc
	autocmd!
augroup END

let mapleader = "\<space>"

filetype plugin indent on
syntax enable

set ttimeout
set ttimeoutlen=100

set backspace=indent,eol,start

set autoindent
set smarttab
set cinoptions=N-s,g0

set ignorecase
set smartcase
set incsearch

if has('multi_byte')
	set encoding=utf-8
endif

set fillchars=

if has('multi_byte')
	set listchars=eol:¬,tab:»\ ,trail:·
else
	set listchars=eol:$,tab:>\ ,trail:-
endif

if has('unnamedplus')
	set clipboard=unnamedplus,unnamed
else
	set clipboard+=unnamed
endif

if has('persistent_undo')
	set undofile
	if has('win32')
		set undodir=~/vimfiles/.undo//
	else
		set undodir=~/.vim/.undo//
	endif
endif

if has('win32')
	set backupdir=~/vimfiles/.backup//
	set directory=~/vimfiles/.swap//
else
	set backupdir=~/.vim/.backup//
	set directory=~/.vim/.swap//
endif

set completeopt=menu,menuone,noselect

set wildmenu
set wildmode=longest:full,full
set wildignore+=.hg,.git,.svn                    " version control files
set wildignore+=*.aux,*.out,*.toc                " LaTeX build files
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.class                          " java compiled objects
set wildignore+=*.luac                           " lua byte code
set wildignore+=*.pyc                            " python byte code
set wildignore+=*.sw                             " vim swap files
set wildignore+=*.DS_Store                       " OSX something

set nrformats-=octal
set formatoptions+=j
set fileformats=unix,dos,mac

set number
set relativenumber

set scrolloff=1
set sidescrolloff=5

if has('mouse')
	set mouse=a
endif

set display+=lastline
set laststatus=2
set noshowmode

set autoread
set hidden
set cursorline
set shortmess=atI
set lazyredraw
set splitbelow
set splitright
set belloff=all

set omnifunc=syntaxcomplete#Complete

if version >= 800
	set signcolumn=yes
endif

augroup vimrc
	" automatically resize splits on window resize
	autocmd VimResized * :wincmd =
	" redraw immediately when entering vim
	autocmd VimEnter * redraw!
	" restore line position
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exec "normal! g`\"" | endif
	" switch to/from relative line numbers
	autocmd BufEnter,FocusGained * setlocal number relativenumber
	autocmd BufLeave,FocusLost   * setlocal number norelativenumber
	autocmd InsertEnter * setlocal number norelativenumber
	autocmd InsertLeave * setlocal number relativenumber
	" enable/disable cursor line depending on window focus
	autocmd BufEnter,FocusGained * setlocal number cursorline
	autocmd BufLeave,FocusLost   * setlocal number nocursorline
augroup END

"
" Mappings
"

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
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" execute macro over visual range
function! s:execute_macro_over_visual_range()
	echo "@".getcmdline()
	execute ":'<,'> normal @" . nr2char(getchar())
endfunction

xnoremap @ :<C-u>call <SID>execute_macro_over_visual_range()<CR>

"
" Theme
"
set background=dark
colorscheme gruvbox

"
" ALE
"
let g:ale_sign_error = 'E '
let g:ale_sign_warning = 'W '

"
" Auto-pairs
"
let g:AutoPairsMultilineClose = 0
augroup vimrc
	autocmd FileType vim let b:AutoPairs = {'(': ')', '[': ']', '{': '}', "'": "'", '`': '`'}
augroup END

"
" Denite
"
call denite#custom#option('default', 'auto_resize', 1)
call denite#custom#option('default', 'statusline', 0)
call denite#custom#option('default', 'highlight_mode_normal', 'CursorLine')
call denite#custom#option('default', 'highlight_mode_insert', 'CursorLine')
call denite#custom#option('grep', 'mode', 'normal')
call denite#custom#option('grep', 'auto_resize', 1)
call denite#custom#option('grep', 'statusline', 0)
call denite#custom#option('grep', 'highlight_mode_normal', 'CursorLine')
call denite#custom#option('grep', 'highlight_mode_insert', 'CursorLine')

" build ag ignores from wildignore
let s:ag_ignore = []
for pattern in split(&wildignore, ',')
	let s:ag_ignore += ['--ignore', pattern]
endfor

" file_rec command
if executable('ag')
	call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '--hidden'] + s:ag_ignore + ['-g', ''])
endif

" grep command
if executable('ag')
	call denite#custom#var('grep', 'command', ['ag', '--hidden'] + s:ag_ignore)
	call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', [])
	call denite#custom#var('grep', 'separator', [])
	call denite#custom#var('grep', 'final_opts', [])
endif

" mappings
call denite#custom#map('insert', '<Esc>', '<denite:enter_mode:normal>')
call denite#custom#map('normal', '<Esc>', '<denite:quit>')
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

nnoremap <leader>b :Denite buffer<cr>
nnoremap <leader>f :Denite file_rec<cr>
nnoremap <leader>o :Denite outline<cr>
nnoremap <leader>/ :Denite -buffer-name=grep grep<cr>

"
" Incsearch, Incsearch-fuzzy, Asterisk
"
" HACK - don't break basic search if plugin is not installed
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

"
" jedi-vim - disable autocompletions, neocomplete does this
"
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0

"
" Modestatus
"
let g:modestatus#statusline = [
	\		['mode'],
	\		['fugitive_branch', 'signify_added', 'signify_modified', 'signify_removed'],
	\		'filename', 'modified', 'readonly', 'filetype', 'ale_errors', 'ale_warnings', 'ale_style_errors', 'ale_style_warnings',
	\		'%=',
	\		'expandtab', 'shiftwidth', 'encoding', 'bomb', 'fileformat',
	\		['line', 'column', 'line_percent']
	\	]

let g:modestatus#statusline_override_denite = [['denite_mode'], 'denite_sources', 'denite_path', 'filetype', '%=', ['line', 'line_max', 'line_percent']]
let g:modestatus#statusline_override_fugitiveblame = ['filetype', '%=', ['line', 'line_max', 'line_percent']]
let g:modestatus#statusline_override_qf = [['mode'], 'buftype', 'filetype', '%=', ['line', 'line_max', 'line_percent']]

augroup vimrc
	" overrides
	autocmd FileType denite call modestatus#setlocal('denite')
	autocmd FileType fugitiveblame call modestatus#setlocal('fugitiveblame')
	autocmd FileType qf call modestatus#setlocal('qf')
augroup END

call modestatus#options#add('mode', 'color', 'ModestatusMode')
call modestatus#options#add('fugitive_branch', 'color', ['Modestatus2', 'Modestatus2NC'])
call modestatus#options#add('signify_added', 'color', ['Modestatus2Green', 'Modestatus2NCGreen'])
call modestatus#options#add('signify_modified', 'color', ['Modestatus2Aqua', 'Modestatus2NCAqua'])
call modestatus#options#add('signify_removed', 'color', ['Modestatus2Red', 'Modestatus2NCRed'])
call modestatus#options#add('filename', 'color', ['ModestatusBold', 'ModestatusNC'])
call modestatus#options#add('modified', 'color', ['ModestatusRedBold', 'ModestatusNCRedBold'])
call modestatus#options#add('readonly', 'color', ['ModestatusRed', 'ModestatusNCRed'])
call modestatus#options#add('ale_errors', 'color', ['ModestatusRed', 'ModestatusNCRed'])
call modestatus#options#add('ale_errors', 'format', '•%s')
call modestatus#options#add('ale_warnings', 'color', ['ModestatusYellow', 'ModestatusNCYellow'])
call modestatus#options#add('ale_warnings', 'format', '•%s')
call modestatus#options#add('ale_style_errors', 'color', ['ModestatusPurple', 'ModestatusNCPurple'])
call modestatus#options#add('ale_style_errors', 'format', '•%s')
call modestatus#options#add('ale_style_warnings', 'color', ['ModestatusAqua', 'ModestatusNCAqua'])
call modestatus#options#add('ale_style_warnings', 'format', '•%s')
call modestatus#options#add('expandtab', 'format', '[%s')
call modestatus#options#add('shiftwidth', 'format', '%s]')
call modestatus#options#add('encoding', 'format', '[%s')
call modestatus#options#add('encoding', 'separator', '')
call modestatus#options#add('bomb', 'format', '-%s')
call modestatus#options#add('bomb', 'separator', '')
call modestatus#options#add('fileformat', 'format', ':%s]')
call modestatus#options#add('line', 'color', ['Modestatus2', 'Modestatus2NC'])
call modestatus#options#add('line', 'separator', '')
call modestatus#options#add('column', 'format', ',%s')
call modestatus#options#add('column', 'color', ['Modestatus2', 'Modestatus2NC'])
call modestatus#options#add('line_max', 'format', '/%s')
call modestatus#options#add('line_max', 'color', ['Modestatus2', 'Modestatus2NC'])
call modestatus#options#add('line_percent', 'color', ['Modestatus2', 'Modestatus2NC'])
call modestatus#options#add('denite_mode', 'color', 'ModestatusMode')
call modestatus#options#add('denite_sources', 'color', ['ModestatusBold', 'ModestatusNC'])

"
" Neocomplete
"
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1

if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns['php'] = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns['c'] = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns['cpp'] = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

if !exists('g:neocomplete#force_omni_input_patterns')
	let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns['javascript'] = '[^. \t]\.\w*'
let g:neocomplete#force_omni_input_patterns['python'] = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

augroup vimrc
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=tern#Complete
	autocmd FileType python setlocal omnifunc=jedi#completions
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

" tab completion
inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<s-tab>"
inoremap <expr><esc> pumvisible() ? "\<C-y>\<esc>" : "\<esc>"

"
" Netrw - DISABLE
"
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

"
" Signify
"
let g:signify_sign_change = '~'
let g:signify_sign_delete = '-'

"
" Targets
"
let g:targets_pairs = '() {} [] <>'
let g:targets_argTrigger = ','
let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'

"
" Undotree
"
let g:undotree_WindowLayout = 2
let g:undotree_DiffAutoOpen = 0
