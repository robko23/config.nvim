require("user.util")
require("user.opts")

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

require("lazy").setup({
	{ import = "user.plugins.colorscheme" },
	{ import = "user.plugins.misc" },
	{ import = "user.plugins.lualine" },
	{ import = "user.plugins.trouble" },
	{ import = "user.plugins.treesitter" },
	{ import = "user.plugins.telescope" },
	{ import = "user.plugins.lspconfig" },
	{ import = "user.plugins.flash" },
	{ import = "user.plugins.gitsigns" },
	{ import = "user.plugins.aerial" },
	-- { import = "user.plugins.tabnine" }
}, {
	change_detection = {
		enabled = false,
	}
})

require("user.keymap")
