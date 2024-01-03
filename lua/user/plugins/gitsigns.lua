return {
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function(self, opts)
			require('gitsigns').setup({
				on_attach = function(bufnr)
					local gs = require('gitsigns')

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map('n', ']c', function()
						if vim.wo.diff then return ']c' end
						vim.schedule(function() gs.next_hunk() end)
						return '<Ignore>'
					end, { expr = true, desc = "Next change" })

					map('n', '[c', function()
						if vim.wo.diff then return '[c' end
						vim.schedule(function() gs.prev_hunk() end)
						return '<Ignore>'
					end, { expr = true, desc = "Prev change" })

					-- Actions
					map('n', '<leader>gs', gs.stage_hunk, { desc = "[G]it [S]tage" })
					map('n', '<leader>gr', function()
						vim.ui.input({
							prompt = "Reset current hunk? (y/n)",
							default = "y",
						}, function(input)
							if type(input) == "nil" or input == "y" then
								gs.reset_hunk()
							end
						end)
					end, { desc = "[G]it [R]eset" })
					map('n', '<leader>gu', gs.undo_stage_hunk, { desc = "[G]it [U]nstage" })

					map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
						{ desc = "Stage selection" })
					map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
						{ desc = "Reset stage selection" })
					map('n', '<leader>gS', gs.stage_buffer, { desc = "[G]it [S]age buffer" })
					map('n', '<leader>gR', gs.reset_buffer, { desc = "[G]it [R]eset buffer" })
					map('n', '<leader>gp', gs.preview_hunk, { desc = "[G]it [P]review" })

					map('n', '<leader>gB', function() gs.blame_line { full = true } end, { desc = "[G]it [B]lame" })
					map('n', '<leader>gb', gs.toggle_current_line_blame, { desc = "[G]it [B]lame toggle" })
					map('n', '<leader>gd', gs.diffthis, { desc = "[G]it [D]iff" })
					map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = "[G]it [D]iff" })
					map('n', '<leader>gt', gs.toggle_deleted, { desc = "[G]it [T]oggle deleted" })

					-- Text object
					map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
				end
			})
		end
	}
}
