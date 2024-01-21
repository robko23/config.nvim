return {
	{
		'codota/tabnine-nvim',
		build = "./dl_binaries.sh",
		event = "VeryLazy",
		config = function(self, opts)
			require('tabnine').setup({
				disable_auto_comment = true,
				accept_keymap = "<C-a>",
				dismiss_keymap = "<C-]>",
				debounce_ms = 800,
				suggestion_color = { gui = "#9399b2", cterm = 244 },
				exclude_filetypes = { "TelescopePrompt", "NvimTree" },
				log_file_path = nil, -- absolute path to Tabnine log file
			})
		end
	},
}
