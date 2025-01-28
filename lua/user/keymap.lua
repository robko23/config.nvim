-- Technically this isn't a keymap, but command abbr
vim.cmd("cnoreabbrev W! w!")
vim.cmd("cnoreabbrev Q! q!")
vim.cmd("cnoreabbrev Qall! qall!")
vim.cmd("cnoreabbrev Wq wq")
vim.cmd("cnoreabbrev Wa wa")
vim.cmd("cnoreabbrev wQ wq")
vim.cmd("cnoreabbrev WQ wq")
vim.cmd("cnoreabbrev W w")
vim.cmd("cnoreabbrev Q q")
vim.cmd("cnoreabbrev Qa qa")
vim.cmd("cnoreabbrev Qall qall")

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Undo tree" })

vim.keymap.set("n", "<leader>de", "<cmd>Trouble diagnostics filter.severity = vim.diagnostic.severity.ERROR<cr>",
	{ desc = "[D]iagnostics - [E]rrors" })
vim.keymap.set("n", "<leader>dd", "<cmd>Trouble diagnostics<cr>", { desc = "[D]iagnostics (all)" })

vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })

-- Vmap for maintain Visual Mode after shifting > and <
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")


vim.keymap.set("n", "j", "jzz", { remap = false })
vim.keymap.set("n", "k", "kzz", { remap = false })
vim.keymap.set("n", "G", "Gzz", { remap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set({ "n", "v" }, "<leader>p", "\"_dP", { desc = "Paste without overriding current register" })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
