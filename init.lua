vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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

function Get_reg(char)
	return vim.api.nvim_exec([[echo getreg(']]..char..[[')]], true):gsub("[\n\r]", "^J")
end

require("lazy").setup({
	-- Theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			vim.cmd.colorscheme "catppuccin-mocha"
		end
	},
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
				lualine_c = {'Get_reg("%")'}
			}
		},
	},
	{
		'folke/which-key.nvim',
		opts = {}
	},

	{
		'numToStr/Comment.nvim',
		opts = {
		}
	},

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

	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ 'williamboman/mason.nvim', config = true },
			'williamboman/mason-lspconfig.nvim',

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim',       opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
		},
	},

	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',

			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',

			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',

		},
	},

	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			src = {
				cmp = { enabled = true },
			},
		},
	},

	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = 'ibl',
		opts = {},
	},

	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {}
	},

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
	},

	{
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = {
			'nvim-telescope/telescope.nvim'
		},
		config = function (self, opts)
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end
	},

	{
		'mbbill/undotree'
	},

	{
		"nvim-treesitter/nvim-treesitter-context"
	},

	{
		"preservim/nerdtree",
		lazy = true,
	},

	-- {
	-- 	"simrat39/rust-tools.nvim",
	-- 	lazy = true,
	-- 	opts = function()
	-- 		local ok, mason_registry = pcall(require, "mason-registry")
	-- 		local adapter ---@type any
	-- 		if ok then
	-- 			-- rust tools configuration for debugging support
	-- 			local codelldb = mason_registry.get_package("codelldb")
	-- 			local extension_path = codelldb:get_install_path() .. "/extension/"
	-- 			local codelldb_path = extension_path .. "adapter/codelldb"
	-- 			local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
	-- 			adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
	-- 		end
	-- 		return {
	-- 			dap = {
	-- 				adapter = adapter,
	-- 			},
	-- 			tools = {
	-- 				on_initialized = function()
	-- 					vim.cmd([[
	-- 					augroup RustLSP
	-- 					autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
	-- 					autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
	-- 					autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
	-- 					augroup END
	-- 					]])
	-- 				end,
	-- 			},
	-- 		}
	-- 	end,
	-- 	config = function() end,
	-- }
})

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect,preview'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })


-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	local diag = function(next)
		local get = next and vim.diagnostic.get_next or vim.diagnostic.get_prev
		local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
		return function()
			-- jumps to the most severe diagnostic in current buffer
			local jumped = false
			for i = 1, 4, 1 do
				local d = get({ severity = i })
				if type(d) == "table" then
					go({ severity = i })
					jumped = true
					break
				end
			end
			if not jumped then
				vim.notify("No diagnostic available", vim.log.levels.INFO)
			end
		end
	end

	local map = function(mode, keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
	end
	local nmap = function(keys, func, desc)
		map('n', keys, func, desc)
	end

	nmap("]d", diag(true), "Next diagnostic")
	nmap("[d", diag(false), "Prev diagnostic")

	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
	map("v", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	nmap('<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat')
	vim.keymap.set('n', "=", function ()
		vim.lsp.buf.format()
	end, {})

	nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
	nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	local hover_action = function()
		print("in hover_action")
		if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
			require("crates").show_popup()
		else
			vim.lsp.buf.hover()
		end
	end
	nmap('K', hover_action, 'Hover Documentation')
	nmap('<C-q>', hover_action, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	-- Lesser used LSP functionality
	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')

	-- vim.keymap.del('n', "=")
	-- vim.keymap.set("n", "==", function ()
	-- 	vim.buf.lsp.format()
	-- end)

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	rust_analyzer = {
		keys = {
			{ "K",          "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
			{ "<leader>cR", "<cmd>RustCodeAction<cr>",   desc = "Code Action (Rust)" },
			{ "<leader>dr", "<cmd>RustDebuggables<cr>",  desc = "Run Debuggables (Rust)" },
		},
		settings = {
			["rust-analyzer"] = {
				cargo = {
					allFeatures = true,
					loadOutDirsFromCheck = true,
					runBuildScripts = true,
				},
				-- Add clippy lints for Rust.
				checkOnSave = {
					allFeatures = true,
					command = "check",
					extraArgs = { "--no-deps" },
				},
				procMacro = {
					enable = true,
					ignored = {
						["async-trait"] = { "async_trait" },
						["napi-derive"] = { "napi" },
						["async-recursion"] = { "async_recursion" },
					},
				},
			},
		},

	},
	-- tsserver = {},
	-- html = { filetypes = { 'html', 'twig', 'hbs'} },

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
			-- diagnostics = { disable = { 'missing-fields' } },
		},
	},
	taplo = {}
}

-- Setup neovim lua configuration
require('neodev').setup()


-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup({
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require('lspconfig')[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		})
	end,
	-- ["rust_analyzer"] = function (_)
	-- 	local rt = require("rust-tools")
	-- 	rt.setup({
	-- 	})
	-- 	require('lspconfig')["rust_analyzer"].setup({
	-- 		capabilities = capabilities,
	-- 		on_attach = on_attach,
	-- 		settings = servers["rust_analyzer"],
	-- 		filetypes = (servers["ust_analyze"] or {}).filetypes,
	-- 	})
	-- end
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}


cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	completion = {
		completeopt = 'menu,menuone,noinsert',
	},
	mapping = cmp.mapping.preset.insert {
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete {},
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = "crates" },
		{ name = 'path' },
	},
}

local function setup_telescope()
	local telescope = require("telescope")
	local tb = require("telescope.builtin")

	pcall(telescope.load_extension, 'fzf')

	vim.keymap.set("n", "<leader>fF", tb.find_files, { desc = "Find in files (all)" })
	vim.keymap.set("n", "<leader>ff", tb.git_files, { desc = "Find in files (git tracked)" })
	vim.keymap.set("n", "<leader>fb", tb.buffers, { desc = "Find in open buffers" })
	vim.keymap.set("n", "<leader>fm", tb.marks, { desc = "Find in marks" })
	vim.keymap.set("n", "<leader>fg", tb.live_grep, { desc = "Grep in git files" })
end

local function setup_which_key()
	local wk = require("which-key")
	wk.register({
		['<leader>f'] = { '[F]ind ...' },
		['<leader>c'] = { '[C]ind ...' },
	}, { mode = 'n' })
end

setup_telescope()
setup_which_key()

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Undo tree" })
vim.keymap.set("n", "<M-1>", function()
	print("Hello")
end)

vim.opt.tabstop = 4
vim.opt.shiftround = true
vim.opt.softtabstop = 4
vim.opt.expandtab = false

vim.opt.wrap = false

vim.opt.undodir = vim.fn.stdpath("data") .. "undodir"
vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.keymap.set("n", "j", "jzz", { remap = true })
vim.keymap.set("n", "k", "kzz", { remap = true })
vim.keymap.set("n", "G", "Gzz", { remap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>p", "\"_dP", { desc = "Paste without overriding current register" })
