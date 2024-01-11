vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Undo tree" })

vim.keymap.set("n", "<leader>dd", function()
	require("trouble").open()
end, { desc = "[D]iagnostics in [d]ocument" })

vim.keymap.set("n", "<leader>dw", function()
	require("trouble").open("workspace_diagnostics")
end, { desc = "[D]iagnostics in [w]orkspace" })

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
vim.keymap.set({"n", "v"}, "<leader>p", "\"_dP", { desc = "Paste without overriding current register" })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
