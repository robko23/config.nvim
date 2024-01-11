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
		opts = {
			pickers = {
				buffers = {
					attach_mappings = function(prompt_bufnr, map)
						local action_state = require('telescope.actions.state')
						local actions = require('telescope.actions')
						local delete_buf = function()
							local current_picker = action_state.get_current_picker(prompt_bufnr)
							local multi_selections = current_picker:get_multi_selection()

							if next(multi_selections) == nil then
								local selection = action_state.get_selected_entry()
								actions.close(prompt_bufnr)
								vim.api.nvim_buf_delete(selection.bufnr, { force = true })
							else
								actions.close(prompt_bufnr)
								for _, selection in ipairs(multi_selections) do
									vim.api.nvim_buf_delete(selection.bufnr, { force = true })
								end
							end
						end

						map('n', 'd', delete_buf)
						return true
					end
					-- attach_mappings = function(prompt_bufnr, map)
					-- 	local delete_buf = function()
					-- 		local current_picker = action_state.get_current_picker(prompt_bufnr)
					-- 		local multi_selections = current_picker:get_multi_selection()
					--
					-- 		if next(multi_selections) == nil then
					-- 			local selection = action_state.get_selected_entry()
					-- 			actions.close(prompt_bufnr)
					-- 			vim.api.nvim_buf_delete(selection.bufnr, { force = true })
					-- 		else
					-- 			actions.close(prompt_bufnr)
					-- 			for _, selection in ipairs(multi_selections) do
					-- 				vim.api.nvim_buf_delete(selection.bufnr, { force = true })
					-- 			end
					-- 		end
					--
					-- 		map('i', '<C-x>', delete_buf)
					-- 		return true
					-- 	end
					-- 	require('telescope.builtin').buffers(require('telescope.themes').get_dropdown(opts))
					-- end
				}
			},
			extensions = {
				file_browser = {
					-- disables netrw and use telescope-file-browser in its place
					hijack_netrw = true,
					grouped = true,
					auto_depth = true,
					hide_parent_dir = true
				},
			},
		},
		config = function(self, opts)
			require("telescope").setup(opts)

			local telescope = require("telescope")
			local tb = require("telescope.builtin")

			pcall(telescope.load_extension, 'fzf')

			vim.keymap.set("n", "<leader>ff", tb.find_files, { desc = "Find in files (all)" })
			vim.keymap.set("n", "<leader>fF", tb.git_files, { desc = "Find in files (git tracked)" })
			vim.keymap.set("n", "<leader>fb", tb.buffers, { desc = "Find in open buffers" })
			vim.keymap.set("n", "<leader>fm", tb.marks, { desc = "Find in marks" })
			vim.keymap.set("n", "<leader>fg", tb.live_grep, { desc = "Grep in git files" })
			vim.keymap.set({ "n", "v" }, "<leader>fB", ":Telescope file_browser<CR>",
				{ noremap = true, desc = "[F]ile [B]rowser" })
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

	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function(self, opts)
			require("telescope").load_extension("file_browser")
		end
	}
}
