return {
	{
		-- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
		priority = 1000,
		config = function(self, opts)
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all"
				ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'css', 'dockerfile', 'html', 'json', 'proto', 'sql', 'toml', 'yaml' },
				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,
				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,
				-- List of parsers to ignore installing (or "all")
				ignore_install = {},
				modules = {},
				---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
				highlight = {
					enable = true,
					-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
					-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
					-- the name of the parser)
					-- list of language that will be disabled
					-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
					disable = function(_, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "vss", -- set to `false` to disable one of the mappings
						node_incremental = false, --"vsn",
						scope_incremental = "vsn",
						node_decremental = "vsr",
					},
				},
				rainbow = {
					enable = true,
					extended_mode = true,
					max_file_lines = nil,
				}
			})
		end
	},
}
