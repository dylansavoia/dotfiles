vim.g.mapleader = " "

require('settings')
require('mappings')

-- Bootstrap Lazy Package Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup ({
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	{
		'folke/tokyonight.nvim',
		config = function()
			vim.cmd( 'colorscheme tokyonight-night')
		end
	},

	{'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
    {'nvim-treesitter/playground', cmd="TSPlaygroundToggle"},

    {'mbbill/undotree', cmd="UndotreeToggle"},

    {'echasnovski/mini.comment', version = '*', event = "VeryLazy",
        config = function() require("mini.comment").setup({}) end
    },

	{"kylechui/nvim-surround", version = "*", event = "VeryLazy",
        config = function() require("nvim-surround").setup({}) end
    },

    "vifm/neovim-vifm",
    {
        "ggandor/leap.nvim", config = function ()
            require('leap').add_default_mappings(true)
            require('leap').opts.safe_labels = {"s", "f", "n", "o", "d", "m", "u", "r", "t", "/", "z"}
            require('leap').opts.labels      = {"s", "f", "n", "j", "k", "l", "h", "o", "d", "w", "e", "m", "b", "u", "y", "v", "r", "g", "t", "c", "x", "/", "z"}
        end
    },
    -- {"edluffy/hologram.nvim",
    --     config = function () require('hologram').setup{ auto_display = true } end
    -- },

    {'echasnovski/mini.pairs', version = '*', event = "VeryLazy",
        config = function() require("mini.pairs").setup({}) end
    },

    {
        'notjedi/nvim-rooter.lua',
        config = function() require'nvim-rooter'.setup() end
    },

    {'lukas-reineke/indent-blankline.nvim', main = "ibl", opts = {},
    	config = function() require("ibl").setup() end
    },
    {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    {'kiyoon/telescope-insert-path.nvim'},

    {
      'VonHeikemen/lsp-zero.nvim',
      dependencies = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},             
        {                                      
          'williamboman/mason.nvim',
          build = function()
            pcall(vim.cmd, 'MasonUpdate')
          end,
        },
        {'williamboman/mason-lspconfig.nvim'},

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},    
        {'hrsh7th/cmp-nvim-lsp'},
        {'L3MON4D3/LuaSnip', build = 'make install_jsregexp'},    
        {'saadparwaiz1/cmp_luasnip'},
        {'rafamadriz/friendly-snippets'},
      }
    }
})

