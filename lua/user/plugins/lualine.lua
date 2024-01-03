return {
	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		priority = 1000,
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				theme = 'onedark',
				component_separators = '|',
				section_separators = '',
			},
			sections = {
				lualine_c = { 'Get_reg("%")' }
			}
		},
	},
}
