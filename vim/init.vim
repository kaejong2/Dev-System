
let vim_plug_path = expand('~/.config/nvim/autoload/plug.vim')
if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    echo ""
    silent !mkdir -p ~/.config/nvim/autoload
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let vim_plug_just_installed = 1
endif


" ============================================================================
" Install plug start

call plug#begin("~/.config/nvim/plugged")
" dracular 컬러 스킴 
Plug 'dracula/vim'
" rainbow_parentheses 괄호 색상 구분 
Plug 'junegunn/rainbow_parentheses.vim'
" NERDcommenter 주석 단축키
Plug 'scrooloose/nerdcommenter'
" NERDTree file system 뷰어 창
Plug 'scrooloose/nerdtree'
" Tagbar 코드 변수 함수 뷰어 창 
Plug 'majutsushi/tagbar'
" markdown preview 마크다운 작성 시 창 만들어줌
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
" airline 하단 상단 바에 인코딩 열려있는 파일 등 뷰어
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" fzf vim안에서 fzf사용
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" autoclose 괄호 자동 닫힘
Plug 'Townk/vim-autoclose'
" surround 한번에 괄호 닫기ㅓ
Plug 'tpope/vim-surround'
" indent guide indent 마다 표시
Plug 'nathanaelkane/vim-indent-guides'
" buffet 단축키로 버퍼 이동
Plug 'bagrat/vim-buffet'
" Conquer of Completion 실시간 자동완성
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
" vimspector debug 용도로 사용
Plug 'puremourning/vimspector'
" diminactive 비활성 윈도우 강조
Plug 'blueyed/vim-diminactive'
" gitgutter GIT관련
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
call plug#end()
" Plug Install end
" ============================================================================


" ============================================================================
" Vim settings and mappings
" You can edit them as you wish
syntax on
let fancy_symbols_enabled = 0
set encoding=utf-8
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
set autoread
set number
set nuw=2
set nowrap
set ts=4 sw=4 et
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set hls
set cursorline
set splitbelow
set splitright
set autoindent
set smartindent
set smarttab
set expandtab
set number
set scrolloff=17
set showmatch   " highlight matching braces
set hlsearch
set ignorecase
set t_Co=256
set comments=sl:/*,mb:\ *,elx:\ */      " intelligent comments
set mouse=a
let mapleader = " "
color dracula
" 배경 터미널 색상으로 맞출 때 사용
hi Normal guibg=NONE ctermbg=NONE

" ============================================================================
" insert mode 
imap <C-D> <BS> 
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-k> <Up>
inoremap <C-j> <Down>

" ============================================================================
" Normal mode

nnoremap <leader>q :tabp<CR>
nnoremap <leader>w :tabn<CR>
nnoremap <leader>e :tabclose<CR>
nnoremap <silent><S-h> :bp<CR>
nnoremap <silent><S-l> :bn<CR>

nnoremap <silent> <leader>= :exe "resize +3"<CR>
nnoremap <silent> <leader>- :exe "resize -3"<CR>
nnoremap <silent> <leader>] :exe "vertical resize +8"<CR>
nnoremap <silent> <leader>[ :exe "vertical resize -8"<CR>

nnoremap <Leader>) ciw(<C-r>")<ESC>
nnoremap <Leader>} ciw{<C-r>"}<ESC>
nnoremap <Leader>] ciw[<C-r>"]<ESC>
nnoremap <Leader>> ciw<<C-r>"><ESC>
nnoremap <Leader>" ciw"<C-r>""<ESC>
nnoremap <Leader>' ciw'<C-r>"'<ESC>
nnoremap <Leader>* ciw*<C-r>"*<ESC>

" ============================================================================
" Visual mode

vnoremap <Leader>) c(<C-r>")<ESC>
vnoremap <Leader>] c[<C-r>"]<ESC>
vnoremap <Leader>} c{<C-r>"}<ESC>
vnoremap <Leader>" c"<C-r>""<ESC>
vnoremap <Leader>' c'<C-r>"'<ESC>
vnoremap <Leader>> c<<C-r>"><ESC>


set completeopt+=noinsert
set completeopt-=preview
set wildmode=list:longest

autocmd BufWritePre *.py :%s/\s\+$//e
set shell=/bin/zsh

" ============================================================================
" Terminal mode
nnoremap <silent><F2> 
	\:botright new<CR><bar>
	\:terminal<CR><bar><ESC>
	\:resize 10<CR><bar>
	\:set winfixheight<CR><bar>
	\:set nonu<CR><bar>
	\iLS_COLORS=$LS_COLORS:'di=1;33:ln=36'<CR>
" <ESC> 입력 시 <C-\><C-n> 실행 => 터미널 모드에서 기본 모드로 전환
tnoremap <silent><ESC> <C-\><C-n>

" ============================================================================
" Plug Settings

" indent guides -----------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
hi IndentGuidesOdd  ctermbg=8
hi IndentGuidesEven ctermbg=7

" diminactive -----------------------------
let g:diminactive_enable_focus = 1


" gitgutter -----------------------------
let g:gitgutter_enabled = 1

" Tagbar -----------------------------
let g:diminactive_enable_focus=1
let g:buffet_show_index=1
function! g:BuffetSetCustomColors()
	hi! BuffetTab ctermfg=190 ctermbg=234
	hi! BuffetBuffer ctermfg=85 ctermbg=234
	hi! BuffetCurrentBuffer cterm=bold ctermfg=17 ctermbg=190
	hi! BuffetActiveBuffer cterm=bold ctermfg=white ctermbg=234
endfunction

map <leader>r :Tagbar<CR>
nnoremap <SPACE> <Nop>

" RainbowParentheses -----------------------------
autocmd FileType * RainbowParentheses
let g:rainbow#pairs = [['(', ')'], ['{','}'], ['[',']']]

" NERDTree -----------------------------
map <leader>t :NERDTreeToggle<CR>
map <leader>0 :NERDTree<CR>
map <leader>f :NERDTreeFocus<CR>
let g:NERDTreeWinSize=25
let NERDTreeIgnore = ['\.pyc$', '\.pyo$']

" Fzf ------------------------------
nmap ,e :Files<CR>
nmap ,c :Commands<CR>

" CoC ------------------------------
let g:jedi#completions_enabled = 0
nmap  -  <Plug>(choosewin)
" show big letters
let g:choosewin_overlay_enable = 1
let g:signify_vcs_list = ['git', 'hg']
let g:ConquerTerm_InsertOnEnter = 1
let g:ConquerTerm_CWInsert = 1
" nicer colors
highlight DiffAdd           cterm=bold ctermbg=none ctermfg=119
highlight DiffDelete        cterm=bold ctermbg=none ctermfg=167
highlight DiffChange        cterm=bold ctermbg=none ctermfg=227
highlight SignifySignAdd    cterm=bold ctermbg=237  ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=237  ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227

" Autoclose ------------------------------

" Fix to let ESC work as espected with Autoclose plugin
" (without this, when showing an autocompletion window, ESC won't leave insert
"  mode)
let g:AutoClosePumvisible = {"ENTER": "\<C-Y>", "ESC": "\<ESC>"}

" Yankring -------------------------------
let g:yankring_history_dir = '~/.config/nvim/'
let g:yankring_clipboard_monitor = 0

" Airline ------------------------------
let g:airline_powerline_fonts = 1
let g:airline_theme = 'dracula'
let g:airline#extensions#whitespace#enabled = 0

" Fancy Symbols!!
if fancy_symbols_enabled
    let g:webdevicons_enable = 1
    if !exists('g:airline_symbols')
       let g:airline_symbols = {}
    endif
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = '⭠'
    let g:airline_symbols.readonly = '⭤'
    let g:airline_symbols.linenr = '⭡'
else
    let g:webdevicons_enable = 0
endif

" vimspector "
nnoremap <leader>da :call vimspector#Launch()<CR>
nnoremap <leader>dx :call vimSpector#Reset()<CR>
nnoremap <c-8> :call vimspector#StepOut()<CR>
nnoremap <C-7> :call vimspector#StepInfo()<CR>
nnoremap <C-9> :call vimspector#StepOver()<CR>
nnoremap <leader>d_ :call vimspector#Restart()<CR>
nnoremap <leader>dn :call vimspector#Continue()<CR>
nnoremap <leader>drc :call vimspector#RunToCursor()<CR>
nnoremap <leader>dh :call vimspector#ToggleBreakpoint()<CR>
nnoremap <leader>de :call vimspector#ToggleConditionalBreakpoint()<CR>
nnoremap <leader>dX :call vimspector#ClearBreakpoints()<CR>

" Custom configurations ----------------

" Include user's custom nvim configurations
let custom_configs_path = "~/.config/nvim/custom.vim"
if filereadable(expand(custom_configs_path))
  execute "source " . custom_configs_path
endif

