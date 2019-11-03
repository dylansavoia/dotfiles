call plug#begin('~/.config/nvim/plugged')
" Colors
Plug 'tomasiser/vim-code-dark'
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
" Plug 'Shougo/neosnippet.vim' | Plug 'Shougo/neosnippet-snippets'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'gorkunov/smartpairs.vim'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'tpope/vim-repeat'
Plug 'majutsushi/tagbar'
call plug#end()

"UI and colors
set runtimepath+=~/.fzf
noremap <C-P> :Files<cr>

colorscheme codedark
let g:airline_theme = 'codedark'
highlight EndOfBuffer ctermfg=bg

vmap s S
command! GUI execute 'Tagbar' | winc l | sp | execute 'terminal' | winc h

"Autocompletion and Linting
let g:deoplete#enable_at_startup = 1

imap <expr> <CR>  (pumvisible() ?  "\<c-y>\<c-U>" : "\<CR>")

inoremap <expr><tab> pumvisible() ? "\<down>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<up>" : "\<s-tab>"

" Add preview to see docstrings in the complete window.
set completeopt =menu,menuone,noinsert,noselect,preview
let g:deoplete#sources#jedi#show_docstring = 1

" Close the prevew window automatically on InsertLeave
augroup ncm_preview
    autocmd! InsertLeave <buffer> if pumvisible() == 0|pclose|endif
augroup END

let g:UltiSnipsExpandTrigger="<c-U>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"

let g:ale_lint_on_text_changed = "never"
let g:ale_linters = {
\    "c": ["gcc"],
\}

""Key mappings
nnoremap <silent> <leader>ale :call ALERealtimeToggle()<cr>
nnoremap <silent> <leader>j :ALENextWrap<cr>
nnoremap <silent> <leader>k :ALEPreviousWrap<cr>

" let g:ale_set_quickfix = 1

""Functions
function ALERealtimeToggle()
    if (g:ale_lint_on_text_changed == "always")
        let g:ale_lint_on_text_changed = "never"
    else
        let g:ale_lint_on_text_changed = "always"
    end
    ALEDisable
    ALEEnable
endfun
