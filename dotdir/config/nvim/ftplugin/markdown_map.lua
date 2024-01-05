-- Bold / Italics / Strikethrough
vim.keymap.set('v', '<leader>b', 'Si**<CR>**<CR>', {buffer=true, remap=true})
vim.keymap.set('v', '<leader>i', 'Si_<CR>_<CR>',   {buffer=true, remap=true})
vim.keymap.set('v', '<leader>x', 'Si~~<CR>~~<CR>', {buffer=true, remap=true})

