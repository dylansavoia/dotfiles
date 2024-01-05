local builtin = require('telescope.builtin')
local path_actions = require('telescope_insert_path')

require('telescope').setup {
  defaults = {
    mappings = {
      n = {
        -- E.g. Type `[i`, `[I`, `[a`, `[A`, `[o`, `[O` to insert relative path and select the path in visual mode.
        -- Other mappings work the same way with a different prefix.
        ["["] = path_actions.insert_reltobufpath_visual,
        ["]"] = path_actions.insert_abspath_visual,
        ["{"] = path_actions.insert_reltobufpath_insert,
        ["}"] = path_actions.insert_abspath_insert,
        ["-"] = path_actions.insert_reltobufpath_normal,
        ["="] = path_actions.insert_abspath_normal,
      }
    }
  }
}


-- Mix
vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
vim.keymap.set('n', '<leader>FF', function ()
    builtin.find_files({hidden=true})
end)
vim.keymap.set('n', '<leader>,', builtin.buffers, {})
vim.keymap.set('n', '<leader>:', builtin.command_history, {})
vim.keymap.set('n', '<leader>/', builtin.search_history, {})
vim.keymap.set('n', '<leader>?', builtin.help_tags, {})

-- Global
vim.keymap.set('n', '<leader>gs', function() grepOpts({}) end)

-- Buffer
vim.keymap.set('n', '<leader>bs', function()
    grepOpts({grep_open_files = true})
end)

-- Open
vim.keymap.set('n', '<leader>or', builtin.oldfiles, {})



function grepOpts (opts)
    vim.ui.input({prompt = 'Grep > ' }, function(input)
        if input == nil then return false end
        if input ~= "" then opts["search"] = input end
        builtin.grep_string(opts)
    end)
end
