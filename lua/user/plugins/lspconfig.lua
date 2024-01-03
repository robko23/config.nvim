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

	nmap('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
	map("v", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	nmap('<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat')
	vim.keymap.set('n', "=", function()
		vim.lsp.buf.format()
	end, {})

	nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
	nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

	-- See `:help K` for why this keymap
	local hover_action = function()
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
	-- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	-- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	-- nmap('<leader>wl', function()
	-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, '[W]orkspace [L]ist Folders')

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end

local setup_lsp = function()
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
		taplo = {},
		jsonls = {
			json = {
				schemas = require('schemastore').json.schemas(),
				validate = { enable = true },
			},
		},
		yamlls = {
			yaml = {
				schemaStore = {
					-- You must disable built-in schemaStore support if you want to use
					-- this plugin and its advanced options like `ignore`.
					enable = false,
					-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
					url = "",
				},
				schemas = require('schemastore').yaml.schemas(),
			},
		},
		dockerls = {},
		docker_compose_language_service = {},
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
end

local setup_cmp = function()
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
			{ name = "hadolint" }
		},
	}
end

return {
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
		config = setup_lsp,
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
		config = setup_cmp,
	}
}
