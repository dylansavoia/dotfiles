call plug#begin('~/.config/nvim/plugged')

" Colors
Plug 'tomasiser/vim-code-dark'

" Minimimal
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'gorkunov/smartpairs.vim'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-repeat'

" Bigger
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'honza/vim-snippets'
" Plug 'easymotion/vim-easymotion'
" Plug '/incsearch'

" Dismissed
" Plug 'majutsushi/tagbar'

call plug#end()

" UI and colors
colorscheme codedark
" let g:airline_theme = 'codedark'
highlight EndOfBuffer ctermfg=bg

let g:fzf_buffers_jump = 1

"""""""""""""""""""""""""""""""""""""""""""""
" From here downwards it's all about coc.nvim
"""""""""""""""""""""""""""""""""""""""""""""
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
let g:coc_snippet_next = '<tab>'
