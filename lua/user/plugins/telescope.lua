return {
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- Fuzzy Finder Algorithm which requires local dependencies to be built.
			-- Only load if `make` is available. Make sure you have the system
			-- requirements installed.
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
			},
		},
		config = function(self, opts)
			require("telescope").setup(opts)

			local telescope = require("telescope")
			local tb = require("telescope.builtin")

			pcall(telescope.load_extension, 'fzf')

			vim.keymap.set("n", "<leader>fF", tb.find_files, { desc = "Find in files (all)" })
			vim.keymap.set("n", "<leader>ff", tb.git_files, { desc = "Find in files (git tracked)" })
			vim.keymap.set("n", "<leader>fb", tb.buffers, { desc = "Find in open buffers" })
			vim.keymap.set("n", "<leader>fm", tb.marks, { desc = "Find in marks" })
			vim.keymap.set("n", "<leader>fg", tb.live_grep, { desc = "Grep in git files" })
		end
	},

	{
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = {
			'nvim-telescope/telescope.nvim'
		},
		config = function(self, opts)
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end
	},

}
