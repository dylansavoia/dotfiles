nnoremap qc :copen<cr>
nnoremap ql :lopen<cr>
nnoremap <A-j> :cnext<CR>
nnoremap <A-k> :cprev<CR>

nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

nnoremap zh zt
nnoremap zl zb

nnoremap * *N
noremap <Tab> gt
nnoremap <S-j> <C-^>
vmap s S
imap <c-x><c-p> <plug>(fzf-complete-path)

nnoremap <A-h> [s1z=
nnoremap <A-l> ]s1z=

tnoremap <C-w><C-h> <C-\><C-N><C-w>h
tnoremap <C-w><C-j> <C-\><C-N><C-w>j
tnoremap <C-w><C-k> <C-\><C-N><C-w>k
tnoremap <C-w><C-l> <C-\><C-N><C-w>l

" Leader Based
let mapleader = " "
nnoremap <silent> <leader>h :nohlsearch<cr>
nnoremap <leader>sp :set spell<cr>
nnoremap <leader>g/ :vimgrep // **<left><left><left><left>
nmap     <leader>gs <leader>g/
nnoremap <leader>sh :Term<cr>

nnoremap <leader>f  :Files<cr>
nnoremap <leader>b  :Buffers<cr>
nnoremap <leader>l  :BLines<cr>
nnoremap <leader>gl :Lines<cr>
nnoremap <leader>w  :Windows<cr>
nnoremap <leader>/  :History/<cr>
nnoremap <leader>?  :History/<cr>
nnoremap <leader>:  :History:<cr>

vnoremap <Leader>r :yank <bar> call Run(@")<CR>
autocmd Filetype python :nnoremap <Leader>r :call Run("python ".@%)<CR>
autocmd Filetype c :nnoremap <Leader>r :call Run("make; a.out")<CR>
"For some arcane reason \x80ku translates to <Up>
nnoremap <Leader>R :call Run("\x80ku")<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""      Custom Function       """"""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""
command! Term vs | execute 'terminal' | startinsert 
command! PlaylistClean call PlaylistClean()

function PlaylistClean()
    call feedkeys(":%s/\\v(.{-}) - ([^-]+)-[^.]+\\.mp3/\\2 - \\1.mp3\<CR>")
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
    call feedkeys("i".exec_cmd."\n\<c-\>\<c-n>:sb ".curr_buf."\<CR>")
endfun

command! -nargs=1 -range Filter call Filter(<f-args>)
" function Filter(str)
"     call feedkeys("gvyo\<ESC>p:.! ".a:str."\<CR>ddgvpkVjjJ`[x")
" endfun
