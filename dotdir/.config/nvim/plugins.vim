call plug#begin('~/.config/nvim/plugged')

" Minimimal
Plug 'joshdick/onedark.vim'
Plug 'tpope/vim-surround'
" Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim'
Plug 'gorkunov/smartpairs.vim'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-repeat'
Plug 'itchyny/lightline.vim'
Plug 'vifm/vifm.vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'airblade/vim-rooter'

" Bigger
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lervag/vimtex'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'honza/vim-snippets'
" Plug 'easymotion/vim-easymotion'
" Plug '/incsearch'

" Dismissed
" Plug 'majutsushi/tagbar'

call plug#end()

" UI and colors
let g:onedark_color_overrides = {
\ "black": {"gui": "{{bkg}}", "cterm": "235", "cterm16": "0" },
\ "cursor_grey":  {"gui": "{{bkg_alt}}", "cterm": "235", "cterm16": "0" },
\ "visual_grey":  {"gui": "{{bkg_alt}}", "cterm": "235", "cterm16": "0" },
\ "menu_grey":    {"gui": "{{bkg_alt}}", "cterm": "235", "cterm16": "0" },
\ "special_grey": {"gui": "{{bkg_alt}}", "cterm": "235", "cterm16": "0" },
\}

set termguicolors
colorscheme onedark

let g:lightline = {'colorscheme': 'onedark'}
let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'down':  '40%'}
let g:colorizer_auto_filetype='css,html'
let g:goyo_width = 120

let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1
let g:vifm_replace_netrw = 1

let g:rooter_cd_cmd = 'tcd'
let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_silent_chdir = 1

lua require 'colorizer'.setup ({'css', 'html'})


""""""""""""""""""""""""""""""""""""""""""""""
"                 Vimtex                     "
""""""""""""""""""""""""""""""""""""""""""""""
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

"""""""""""""""""""""""""""""""""""""""""""""
" From here downwards it's all about coc.nvim
"""""""""""""""""""""""""""""""""""""""""""""
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
let g:coc_snippet_next = '<tab>'
vmap <Tab> <Plug>(coc-snippets-select)
