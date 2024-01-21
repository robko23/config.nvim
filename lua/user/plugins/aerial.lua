return {
	{
		'stevearc/aerial.nvim',
		opts = {
			default_direction = "prefer_left",
		},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons"
		},

		config = function(self, opts)
			require("aerial").setup(opts)
			vim.keymap.set("n", "<leader>ot", "<cmd>AerialToggle!<CR>", { desc = "[O]utline [T]oggle" })
		end
	}
}
