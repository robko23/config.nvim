function Get_reg(char)
	return vim.api.nvim_exec([[echo getreg(']] .. char .. [[')]], true):gsub("[\n\r]", "^J")
end
