local is_termux = vim.fn.getenv('ANDROID_ROOT') ~= vim.NIL

vim.opt.nu = not(is_termux)
vim.opt.relativenumber = not(is_termux)

vim.opt.tabstop     = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4
vim.opt.expandtab   = true

vim.opt.smartindent = true
vim.opt.ignorecase  = true
vim.opt.smartcase   = true
vim.opt.linebreak   = true
vim.opt.wrap        = true

vim.opt.hlsearch    = true
vim.opt.incsearch   = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 4
vim.opt.signcolumn = is_termux and "no" or "auto"
vim.opt.isfname:append("@-a")

-- vim.opt.updatetime = 50
-- vim.opt.colorcolumn = "80"
vim.opt.conceallevel = 2

vim.opt.title = true
vim.opt.cursorline = true
vim.opt.hidden = true
vim.opt.clipboard:append("unnamedplus")

vim.opt.switchbuf = "useopen"
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.autoread = true

vim.g.python3_host_prog = "/usr/bin/python3"


-- Autocommands
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    pattern = {"*/Server Content/*", "/tmp/qutebrowser-editor*"},
    callback = function () vim.opt.filetype = "markdown" end
})


-- Execute On Save
vim.api.nvim_create_autocmd({"BufWritePost"}, {
    pattern = {"*"},
    callback = function ()
        vim.cmd("silent !.exec_on_save.sh %")
    end
})


vim.api.nvim_create_autocmd({"VimResized"}, {
    pattern = {"*"},
    callback = function () vim.cmd("wincmd =") end
})

-- Auto create parent folder if it doesn't exist
vim.api.nvim_create_autocmd({"BufWritePre", "FileWritePre"}, {
    pattern = {"*"},
    callback = function ()
        vim.api.nvim_exec("if @% !~# '\\(://\\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif", true)
    end
})
