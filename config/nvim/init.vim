call plug#begin()

" appearance
Plug 'chriskempson/base16-vim'
Plug 'kernan/vim-modestatus'
" languages
Plug 'sheerun/vim-polyglot'
" syntax checking
Plug 'neomake/neomake'
" code completion
Plug 'shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'carlitux/deoplete-ternjs'
Plug 'zchee/deoplete-clang'
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-zsh'
" vcs integration
Plug 'mhinz/vim-signify'
" testing
Plug 'junegunn/vader.vim', {'on': 'Vader', 'for': 'vader'}
" unite
Plug 'shougo/denite.nvim'
" other
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-user'
Plug 'milkypostman/vim-togglelist'
Plug 'raimondi/delimitmate'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

call plug#end()

augroup vimrc
	autocmd!
augroup END

" --------
" Settings
" --------

" clear autocmd
augroup vimrc
	autocmd!
augroup END

let mapleader = "\\"
map <space> <leader>

filetype plugin indent on
syntax enable

set ttimeout
set ttimeoutlen=100

set backspace=indent,eol,start

set autoindent
set smarttab

set smartcase
set incsearch
set hlsearch

if has('multi_byte')
	set encoding=utf-8
endif

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
	let g:undodir = util#path_join(g:vimfiles_path, 'undo')
	call util#mkdir_if_none(g:undodir)
	let &undodir=g:undodir
endif

let g:backupdir = util#path_join(g:vimfiles_path, 'backup//')
call util#mkdir_if_none(g:backupdir)
let &backupdir=g:backupdir

let g:swapdir = util#path_join(g:vimfiles_path, 'swap//')
call util#mkdir_if_none(g:swapdir)
let &directory=g:swapdir

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

augroup vimrc
	" automatically resize splits on window resize
	autocmd VimResized * :wincmd =
	" redraw immediately when entering vim
	autocmd VimEnter * redraw!
	" restore line position
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
	" switch to/from relative line numbers
	autocmd BufEnter,FocusGained * setlocal number relativenumber
	autocmd BufLeave,FocusLost   * setlocal number norelativenumber
	autocmd InsertEnter * setlocal number norelativenumber
	autocmd InsertLeave * setlocal number relativenumber
	" enable/disable cursor line depending on window focus
	autocmd BufEnter,FocusGained * setlocal number cursorline
	autocmd BufLeave,FocusLost   * setlocal number nocursorline
	" use syntaxcomplete#Complete when no other completers are set
	if exists('+omnifunc')
		autocmd FileType *
			\ if &omnifunc == '' |
			\   setlocal omnifunc=syntaxcomplete#Complete |
			\ endif
	endif
	" always show the sign column
	autocmd BufEnter * sign define dummy
	autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
augroup END

" -----
" Theme
" -----
let g:base16colorspace = 256
set background=dark
colorscheme base16-monokai

"
" Modestatus
"
hi StatusLine guifg=#a59f85 guibg=#49483e gui=none ctermfg=20 ctermbg=19 cterm=none
hi StatusLineNC guifg=#75715e guibg=#49483e gui=none ctermfg=08 ctermbg=19 cterm=none
hi ModestatusMode guifg=Yellow guibg=#49483e gui=bold ctermfg=Yellow ctermbg=19 cterm=bold
hi ModestatusFilename guifg=#a59f85 guibg=#49483e gui=bold ctermfg=20 ctermbg=19 cterm=bold
hi ModestatusModified guifg=Red guibg=#49483e gui=bold ctermfg=Red ctermbg=19 cterm=bold
hi link ModestatusModifiedNC ModestatusModified
hi ModestatusReadonly guifg=Red guibg=#49483e gui=none ctermfg=Red ctermbg=19 cterm=none
hi link ModestatusReadonlyNC ModestatusReadonly
hi link ModestatusPaste ModestatusReadonly
hi ModestatusError guifg=White guibg=#af0000 gui=none ctermfg=White ctermbg=124 cterm=none
hi ModestatusWarning guifg=Black guibg=#dfaf00 gui=none ctermfg=Black ctermbg=178 cterm=none
hi ModestatusSignifyAdded guifg=#a6e22e guibg=#49483e gui=none ctermfg=2 ctermbg=19 cterm=none
hi link ModestatusSignifyAddedNC ModestatusSignifyAdded
hi ModestatusSignifyModified guifg=#66d9ef guibg=#49483e gui=none ctermfg=4 ctermbg=19 cterm=none
hi link ModestatusSignifyModifiedNC ModestatusSignifyModified
hi ModestatusSignifyRemoved guifg=#f92672 guibg=#49483e gui=none ctermfg=1 ctermbg=19 cterm=none
hi link ModestatusSignifyRemovedNC ModestatusSignifyRemoved

call modestatus#extensions#enable('core')
call modestatus#extensions#enable('loclist')
call modestatus#extensions#enable('signify')
call modestatus#extensions#enable('denite')

let g:modestatus#disable_filetypes = []
let g:modestatus#statusline = {
	\ 'active': {
	\     'left': [
	\         'line_percent',
	\         'position',
	\         'mode',
	\         'filename',
	\         'modified',
	\         'readonly',
	\         'paste',
	\         'filetype',
	\         'encoding',
	\         'fileformat',
	\         'signify_hunk_added',
	\         'signify_hunk_modified',
	\         'signify_hunk_removed',
	\         'loclist_errors',
	\         'loclist_warnings']},
	\ 'inactive': {
	\     'left': [
	\         'filename',
	\         'modified',
	\         'readonly',
	\         'filetype',
	\         'encoding',
	\         'fileformat',
	\         'signify_hunk_added',
	\         'signify_hunk_modified',
	\         'signify_hunk_removed',
	\         'loclist_errors',
	\         'loclist_warnings']}}

let g:modestatus#statusline_override = {'denite': {
  	\ 'active': {
  	\     'left': [
  	\         'denite_line_percent',
  	\         'denite_line',
  	\         'denite_mode',
  	\         'denite_sources',
  	\         'denite_path',
  	\         'filetype']}}}

call modestatus#options#add('line_percent', {'common': {'min_winwidth': 30}})
call modestatus#options#add('position', {'common': {'min_winwidth': 30}})
call modestatus#options#add('filename', {'active': {'color': 'ModestatusFilename'}})
call modestatus#options#add('mode', {'active': {'color': 'ModestatusMode', 'format': (has('multi_byte') ? "\u2039%s\u203A" : '<%s>')}})
call modestatus#options#add('modified', {'active': {'color': 'ModestatusModified'}, 'inactive': {'color': 'ModestatusModifiedNC'}})
call modestatus#options#add('readonly', {'active': {'color': 'ModestatusReadonly'}, 'inactive': {'color': 'ModestatusReadonlyNC'}})
call modestatus#options#add('paste', {'active': {'color': 'ModestatusPaste'}})
call modestatus#options#add('filetype', {'common': {'format': '[%s]', 'min_winwidth': 50}})
call modestatus#options#add('encoding', {'common': {'format': '[%s:', 'separator': '', 'min_winwidth': 70}})
call modestatus#options#add('fileformat', {'common': {'format': '%s]', 'min_winwidth': 70}})
" signify part options
call modestatus#options#add('signify_hunk_added', {'active': {'color': 'ModestatusSignifyAdded'}, 'inactive': {'color': 'ModestatusSignifyAddedNC'}})
call modestatus#options#add('signify_hunk_modified', {'active': {'color': 'ModestatusSignifyModified'}, 'inactive': {'color': 'ModestatusSignifyModifiedNC'}})
call modestatus#options#add('signify_hunk_removed', {'active': {'color': 'ModestatusSignifyRemoved'}, 'inactive': {'color': 'ModestatusSignifyRemovedNC'}})
" loglist part options
call modestatus#options#add('loclist_errors', {'common': {'color': 'ModestatusError'}})
call modestatus#options#add('loclist_warnings', {'common': {'color': 'ModestatusWarning'}})
" denite part options
call modestatus#options#add('denite_line_percent', {'common': {'min_winwidth': 30}})
call modestatus#options#add('denite_line', {'common': {'min_winwidth': 30}})
call modestatus#options#add('denite_sources', {'active': {'color': 'ModestatusFilename'}})
call modestatus#options#add('denite_path', {'common': {'min_winwidth': 50}})
call modestatus#options#add('denite_mode', {'active': {'color': 'ModestatusMode', 'format': (has('multi_byte') ? "\u2039%s\u203A" : '<%s>')}})

" ---------
" Languages
" ---------

"
" C++
"
let g:cpp_class_scope_highlight = 1
let g:cpp_experimental_template_highlight = 0

"
" Go
"
let g:go_fmt_command = 'goimports'

" -------
" Plugins
" -------

"
" DelimitMate
"
let delimitMate_matchpairs = "(:),[:],{:}"
let delimitMate_quotes = "\" ' `"
let delimitMate_expand_cr = 1
let delimitMate_jump_expansion = 1

augroup vimrc
	" filetype specific pairs
	" filetype specific quotes
	autocmd FileType vim let b:delimitMate_quotes = "'"
	" filetype specific nesting
	autocmd FileType python let b:delimitMate_nesting_quotes = ['"']
augroup END

"
" Deoplete
"
let g:deoplete#enable_at_startup = 1
imap <silent><expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
smap <silent><expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab>  pumvisible() ? "\<C-p>" : "\<C-h>"

"
" Denite
"

" settings
call denite#custom#option('default', 'auto_resize', 1)
call denite#custom#option('default', 'statusline', 0)
call denite#custom#option('default', 'highlight_mode_normal', 'CursorLine')
call denite#custom#option('default', 'highlight_mode_insert', 'CursorLine')
call denite#custom#option('grep', 'mode', 'normal')
call denite#custom#option('grep', 'auto_resize', 1)
call denite#custom#option('grep', 'statusline', 0)
call denite#custom#option('grep', 'highlight_mode_normal', 'CursorLine')
call denite#custom#option('grep', 'highlight_mode_insert', 'CursorLine')

" file_rec command
if executable('ag')
	call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

" grep command
if executable('ag')
	call denite#custom#var('grep', 'command', ['ag'])
	call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', [])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
endif

" mappings
call denite#custom#map('insert', '<Esc>', '<denite:enter_mode:normal>')
call denite#custom#map('normal', '<Esc>', '<denite:quit>')
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
nnoremap <leader>f :Denite file_rec<cr>
nnoremap <leader>b :Denite buffer<cr>
nnoremap <leader>/ :Denite -buffer-name=grep grep<cr>

"
" Neomake
"
let g:neomake_error_sign = {'text': 'E', 'texthl': 'ModestatusError'}
let g:neomake_warning_sign = {'text': 'W', 'texthl': 'ModestatusWarning'}

"
" Signify
"
let g:signify_sign_add = '+'
let g:signify_sign_change = '~'
let g:signify_sign_delete = '-'
let g:signify_sign_delete_first_line = '^'

"
" ToggleList
"
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_tquickfix_list_toggle_map = '<leader>q'
let g:lt_height = 10

" --------
" Mappings
" --------
noremap  <left>  <nop>
noremap  <right> <nop>
noremap  <up>    <nop>
noremap  <down>  <nop>
cnoremap <left>  <nop>
cnoremap <right> <nop>
cnoremap <up>    <nop>
cnoremap <down>  <nop>
inoremap <left>  <nop>
inoremap <right> <nop>
inoremap <up>    <nop>
inoremap <down>  <nop>

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

" sudo write file
cmap w!! w !sudo tee > /dev/null %

" Visual mode search
function! s:VSetSearch()
	let temp = @@
	norm! gvy
	let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
	call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
	let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>?<CR>

" Set tab width using a nice prompt
function! s:set_tabs()
	echohl Question
	let l:tabstop = 1 * input('setlocal tabstop = softtabstop = shiftwidth = ')
	let l:et = input('setlocal expandtab = (y/n)')
	echohl None
	if l:tabstop > 0
		let &l:ts = l:tabstop
		let &l:sts = l:tabstop
		let &l:sw = l:tabstop
	endif
	if l:et == "y"
		setlocal expandtab
	else
		setlocal noexpandtab
	end
	echo
	echo "\r"
	call s:summarize_tabs()
endfunction

" Summarize current tab info
function! s:summarize_tabs()
	try
		echomsg 'tabstop=' . &l:ts . ' softtabstop=' . &l:sts . ' shiftwidth=' . &l:sw . ' ' . ((&l:et) ? 'expandtab' : 'noexpandtab')
	endtry
endfunction

command! -nargs=0 SetTabs call s:set_tabs()
command! -nargs=0 SummarizeTabs call s:summarize_tabs()
