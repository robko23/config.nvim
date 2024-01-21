return {
	{
		'folke/which-key.nvim',
		opts = {},
		config = function(self, opts)
			require("which-key").setup(opts)

			local wk = require("which-key")
			wk.register({
				['<leader>f'] = { '[F]ind ...' },
				['<leader>c'] = { '[C]ode ...' },
				['<leader>d'] = { '[D]iagnostic ...' },
				['<leader>t'] = { '[T]odo ...' },
				['<leader>g'] = { '[G]it ...' },
				['<leader>o'] = { '[O]utline ...' },
			}, { mode = 'n' })
		end
	},

	{
		'numToStr/Comment.nvim',
		opts = {
		}
	},

	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = 'ibl',
		opts = {},
	},

	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {}
	},

	{
		'mbbill/undotree'
	},

	{
		"nvim-treesitter/nvim-treesitter-context"
	},

	{
		"b0o/schemastore.nvim",
		lazy = true
	},

	{
		"HiPhish/rainbow-delimiters.nvim"
	},

	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		config = function(self, opts)
			require("todo-comments").setup(opts)

			vim.keymap.set('n', "<leader>tt", function()
				vim.cmd("TodoTelescope")
			end, { desc = "[T]odo [T]elescope" })
		end
	},

	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			src = {
				cmp = { enabled = true },
			},
		},
	},
}
