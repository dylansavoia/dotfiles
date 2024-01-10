-- Per-Line navigation
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'gk', 'k')
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'gj', 'j')

-- Move Cursor and recenter
vim.keymap.set('n', 'zh', 'zt')
vim.keymap.set('n', 'zm', 'z.')
vim.keymap.set('n', 'zl', 'zb')

-- Search Highlight
vim.keymap.set('n', '<leader>h', "<cmd>nohlsearch<CR>")
vim.keymap.set('n', '*', '"syiw<Esc><cmd> let @/ = @s | set hlsearch <CR>')

-- Fixes
vim.keymap.set('n', '<A-h>', '[s1z=')
vim.keymap.set('n', '<A-l>', ']s1z=')

-- Search Highlight
vim.keymap.set('n', '<S-j>', '<C-^>')

-- Move In Terminal Windows
vim.keymap.set('t', '<C-w><C-h>', '<C-\\><C-N><C-w>h')
vim.keymap.set('t', '<C-w><C-j>', '<C-\\><C-N><C-w>j')
vim.keymap.set('t', '<C-w><C-k>', '<C-\\><C-N><C-w>k')
vim.keymap.set('t', '<C-w><C-l>', '<C-\\><C-N><C-w>l')

-- Open
vim.keymap.set('n', '<leader>ot', '<cmd>vs | execute "terminal" | startinsert <CR>')

-- Toggle
vim.keymap.set('n', '<leader>ts', '<cmd>set spell!<CR>')
vim.keymap.set('n', '<leader>tu',  vim.cmd.UndotreeToggle)

-- Misc
vim.keymap.set('n', '<leader>y',  '<cmd>%y<CR>')
vim.keymap.set('n', 'gx',  '<cmd> silent execute "!launcher 0 " . shellescape("<cfile>")<CR>')
vim.keymap.set('n', 'go',  'Bf:l<cmd>e %:h/<cfile><CR>', {silent=true}) -- Tiny macro to jump to file path
vim.keymap.set('n', 'gO',  'Bf:l<cmd> silent execute "!launcher 0 " . shellescape("<cfile>")<CR>', {silent=true}) -- Tiny macro to open link
