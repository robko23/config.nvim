vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Undo tree" })

vim.keymap.set("n", "<leader>de", "<cmd>Trouble diagnostics filter.severity = vim.diagnostic.severity.ERROR<cr>",
	{ desc = "[D]iagnostics - [E]rrors" })
vim.keymap.set("n", "<leader>dd", "<cmd>Trouble diagnostics<cr>", { desc = "[D]iagnostics (all)" })

vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })


vim.keymap.set("n", "j", "jzz", { remap = true })
vim.keymap.set("n", "k", "kzz", { remap = true })
vim.keymap.set("n", "G", "Gzz", { remap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set({ "n", "v" }, "<leader>p", "\"_dP", { desc = "Paste without overriding current register" })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
