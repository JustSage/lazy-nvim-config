return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "folke/neoconf.nvim",                  cmd = "Neoconf",                                config = true },
			{ "folke/neodev.nvim",                   opts = { experimental = { pathStrict = true } } },
			{ "antosha417/nvim-lsp-file-operations", config = true },
		},
		config = function()
			local lspconfig = require("lspconfig")
			local util = require("lspconfig/util")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local ls = require("luasnip")
			local keymap = vim.keymap

			local function organize_imports()
				local params = {
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
				}

				vim.lsp.buf.execute_command(params)
			end

			-- remaps on attach to buffer
			local function on_attach(client, bufnr)
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				if client == "tsserver" then
					client.server_capabilities.documentationFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end

				if client.server_capabilities.signatureHelpProvider then
					keymap.set("n", "<leader>s", vim.lsp.buf.signature_help, { remap = false, silent = true })
				end

				bufopts.buffer = bufnr

				-- SET KEYBINDS
				bufopts.desc = "Peek definition"
				keymap.set("n", "gj", "<Cmd>Lspsaga peek_definition<CR>", bufopts)

				bufopts.desc = "Peek type definition"
				keymap.set("n", "gt", "<Cmd>Lspsaga peek_type_definition<CR>", bufopts)

				bufopts.desc = "Show LSP references"
				keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", bufopts) -- show definition, references

				bufopts.desc = "Go to definition"
				keymap.set("n", "gd", vim.lsp.buf.definition, bufopts) -- go to definition

				bufopts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts) -- go to declaration

				bufopts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", bufopts) -- show lsp implementations

				bufopts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts) -- see available code actions, in visual mode will apply to selection

				bufopts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts) -- smart rename

				bufopts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", bufopts) -- show  diagnostics for file

				bufopts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, bufopts) -- show diagnostics for line

				bufopts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts) -- jump to previous diagnostic in buffer

				bufopts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts) -- jump to next diagnostic in buffer

				bufopts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, bufopts) -- show documentation for what is under cursor

				bufopts.desc = "Show LSP Outline"
				keymap.set("n", "<leader>o", "<Cmd>Lspsaga outline<CR>", bufopts)

				bufopts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", bufopts) -- mapping to restart lsp if necessary

				-- fixes an issue with snippets
				vim.api.nvim_create_autocmd("InsertLeave", {
					callback = function()
						ls.session.current_nodes[vim.api.nvim_get_current_buf()] = nil
					end,
					buffer = bufnr,
				})

				vim.api.nvim_create_user_command("OrganizeImports", organize_imports, { desc = "Organize Imports" })
			end

			-- SETUP DIAGNOSTIC SIGNS AND BEHAVIOR
			for name, icon in pairs(require("sage.util.icons").diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			vim.diagnostic.config({
				virtual_text = {
					prefix = "",
					spacing = 0,
				},
				virtual_lines = false,
				update_in_insert = false,
				underline = true,
				severity_sort = true,
			})

			vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
				local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
				local bufnr = vim.api.nvim_get_current_buf()
				vim.diagnostic.reset(ns, bufnr)
				return true
			end

			-- SETUP HANDLERS FOR HOVER & SIGNATURE HELP
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			})

			-- SUPPRESS ERROR MESSAGES FROM LANG SERVERS
			---@diagnostic disable-next-line: duplicate-set-field
			vim.notify = function(msg, log_level)
				if msg:match("exit code") then
					return
				end
				if log_level == vim.log.levels.ERROR then
					vim.api.nvim_err_writeln(msg)
				else
					vim.api.nvim_echo({ { msg } }, true, {})
				end
			end

			-- SETUP LSP SEVERS
			local capabilities = cmp_nvim_lsp.default_capabilities()

			lspconfig.tsserver.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				root_dir = util.root_pattern("package.json", ".git") or vim.fn.expand("%p"),
				single_file_support = false,
				init_options = {
					preferences = {
						disableSuggestions = true,
					},
				},
				commands = {
					OrganizeImports = {
						organize_imports,
						description = "Organize Imports",
					},
				},
			})

			lspconfig.html.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				single_file_support = true,
				init_options = {
					configurationSection = { "html", "css", "javascript" },
					embeddedLanguages = {
						css = true,
						javascript = true,
					},
					provideFormatter = true,
				},
			})

			lspconfig.cssls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.tailwindcss.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "typescriptreact", "javascriptreact" },
			})

			lspconfig.emmet_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "html", "typescriptreact", "javascriptreact", "ejs" },
				init_options = {
					html = {
						options = {
							-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
							["bem.enabled"] = true,
						},
					},
				},
			})

			lspconfig.pyright.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
				},
				root_dir = function(fname)
					return util.root_pattern(
						"src",
						".git",
						"setup.py",
						"setup.cfg",
						"pyproject.toml",
						"requirements.txt"
					)(fname) or util.path.dirname(fname)
				end,
			})

			lspconfig.clangd.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.bashls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.dockerls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.prismals.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			lspconfig.yamlls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			lspconfig.jsonls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
							},
							maxPreload = 10000,
							preloadFileSize = 10000,
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			})
		end,
	},
}
