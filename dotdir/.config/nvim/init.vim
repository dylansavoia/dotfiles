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
set title
set cursorline
set laststatus=0

set tabstop=4 shiftwidth=4 softtabstop=4 expandtab 
set hidden "Allow buffers to become hidden without saving them first
set clipboard+=unnamedplus "Use Clipboard as default Register
set switchbuf=useopen
set completeopt=menuone
let g:netrw_banner = 0
set autoread "updates files if needed (works with checktime)

set splitbelow
set splitright

" Execute On Save
autocmd BufWritePost ~/.Xresources !xrdb %
autocmd BufWritePost ~/.bashrc !source %
autocmd BufReadPost /tmp/bash-fc.* set filetype=sh

source $HOME/.config/nvim/mappings.vim
source $HOME/.config/nvim/plugins.vim

highlight Normal ctermbg=none
highlight EndOfBuffer ctermbg=none
highlight LineNr ctermbg=none
