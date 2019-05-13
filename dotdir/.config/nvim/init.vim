"UI AND COLORS
" let g:onedark_terminal_italics=1
" colorscheme onedark

"In nvim are default but in Vim they're not
syntax enable
set nocompatible
filetype plugin on
set ignorecase
set smartcase

" let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

set number "Add numebers line
set showcmd
set noshowmode
set cursorline

set tabstop=4 shiftwidth=4 softtabstop=4 expandtab 
set hidden "Allow buffers to become hidden without saving them first
set clipboard+=unnamedplus "Use Clipboard as default Register
set switchbuf+=useopen
set completeopt=menuone
let g:netrw_banner = 0
set autoread "updates files if needed (works with checktime)

set splitbelow
set splitright

"CUSTOM KEYS AND COMMANDS
let mapleader = " "
nnoremap <silent> <leader>n :call ToggleRelative()<cr>
nnoremap <silent> <leader>h :nohlsearch<cr>
nnoremap <leader>T :!ctags -R *<cr>
nnoremap <silent> <leader>P :call PDFToggle()<cr>
nnoremap * *N
noremap <Tab> gt

"Go back to last window
nnoremap <S-j> <C-^>
nnoremap qc :copen<cr>
nnoremap ql :lopen<cr>

nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

nnoremap <Leader>lr "rdd
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

nnoremap <A-j> :cnext<CR>
nnoremap <A-k> :cprev<CR>

tnoremap <Esc> <C-\><C-n>
command! Term vs | execute 'terminal' | startinsert 

command! -nargs=1 -range Filter call Filter(<f-args>)
command! LRUN call Run("\<Up>") 
command! PDF call PDF() 
command! PDFToggle call PDFToggle() 
command! -nargs=* INVERT call Swap(<f-args>)

"For some arcane reason \x80ku translates to <Up>
nnoremap <F5> :call Run("\x80ku")<CR>
autocmd Filetype python :nnoremap <F6> :call Run("python3 ".@%)<CR>
autocmd Filetype c :nnoremap <F6> :call Run("make; a.out")<CR>

"Execute On Save
autocmd BufWritePost ~/.Xresources !xrdb %
autocmd BufWritePost ~/.bashrc !source %
autocmd BufReadPost /tmp/bash-fc.* set filetype=sh

"CUSTOM FUNCTIONS
let g:PDFBool = 0
function PDFToggle()
    if (g:PDFBool == 0)
        autocmd InsertLeave * :w | silent ! pandoc -s -o out.pdf %
        let g:PDFBool = 1
    else
        autocmd! InsertLeave *
        let g:PDFBool = 0
    endif
endfun

function PDF()
    write
    silent ! pandoc -s -o out.pdf %
endfun

function Filter(str)
    call feedkeys("gvyo\<ESC>p:.! ".a:str."\<CR>ddgvpkVjjJ`[x")
endfun

function ToggleRelative()
	if (&relativenumber == 1)
		set norelativenumber
	else
		set relativenumber
	endif
endfun

function Run(str)
    write
    let exec_cmd = substitute(a:str, "\n$", "", "")  
    let curr_buf = expand('%')
    let term_nm = bufnr("term")

    if (term_nm > -1)
        exec "sbuffer ".term_nm
    else
        vs | terminal
    endif

    echom exec_cmd
    call feedkeys("i".exec_cmd."\n\<Esc>:sb ".curr_buf."\<CR>")
endfun

function Swap(str1, str2)
    call feedkeys("0/".a:str1."\<CR>diw/".a:str2."\<CR>viwp\<c-o>P h")
endfun

"COPY ABOVE WORD
function CopyAbove()
    call feedkeys("\<ESC>kyawjf/viwp")
endfun
" autocmd Filetype text :inoremap // <esc>klyiwhjpa

source $HOME/.config/nvim/plugins.vim
