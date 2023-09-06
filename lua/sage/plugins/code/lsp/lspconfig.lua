return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {
				"stylua",
				"shellcheck",
				"shfmt",
				"flake8",
				"eslint_d",
				"prettier",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(plugin, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf",                                config = true },
			{ "folke/neodev.nvim",  opts = { experimental = { pathStrict = true } } },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local util = require("lspconfig/util")
			local lspconfig = require("lspconfig")
			local ls = require("luasnip")

			-- remaps on attach to buffer
			local function on_attach(client, bufnr)
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				client.server_capabilities.documentationFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				if client.server_capabilities.signatureHelpProvider then
					vim.keymap.set("n", "<leader>s", vim.lsp.buf.signature_help, { remap = false, silent = true })
				end

				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)

				vim.api.nvim_create_autocmd("InsertLeave", {
					callback = function()
						ls.session.current_nodes[vim.api.nvim_get_current_buf()] = nil
					end,
					buffer = bufnr,
				})
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local cmp_installed, cmp = pcall(require, "cmp_nvim_lsp")

			if cmp_installed then
				capabilities = vim.tbl_deep_extend("force", capabilities, cmp.default_capabilities())
			else
				capabilities = vim.tbl_deep_extend("force", capabilities, {
					textDocument = {
						documentationFormat = { "markdown", "plaintext" },
						snippetSupport = true,
						preselectSupport = true,
						insertReplaceSupport = true,
						deprecatedSupport = true,
						commitCharactersSupport = true,
						tagSupport = { valueSet = { 1 } },
						labelDetailsSupport = true,
						completion = {
							resolveSupport = {
								properties = {
									"documentation",
									"detail",
									"additionalTextEdits",
									"sortText",
									"filterText",
									"insertText",
									"textEdit",
									"insertTextFormat",
									"insertTextMode",
								},
							},
							insertTextModeSupport = {
								valueSet = {
									1,
									2,
								},
							},
							contextSupport = true,
							insertTextMode = 1,
							completionList = {
								itemDefaults = {
									"commitCharacters",
									"editRange",
									"insertTextFormat",
									"insertTextMode",
									"data",
								},
							},
						},
					},
				})
			end

			local config = {
				virtual_text = {
					prefix = "",
					spacing = 0,
				},
				virtual_lines = false,
				update_in_insert = false,
				underline = true,
				severity_sort = true,
			}

			for name, icon in pairs(require("sage.util.icons").diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			vim.diagnostic.config(config)

			vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
				local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
				local bufnr = vim.api.nvim_get_current_buf()
				vim.diagnostic.reset(ns, bufnr)
				return true
			end

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			})

			-- suppress error messages from lang servers
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

			lspconfig.tsserver.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				root_dir = util.root_pattern("package.json", ".git") or vim.fn.expand("%p"),
				cmd = { "typescript-language-server", "--stdio" },
				filetype = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				single_file_support = true,
				-- init_options = {
				-- 	hostInfo = "neovim",
				-- 	preferences = {
				-- 		includeInlayParameterNameHints = "all",
				-- 		includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				-- 		includeInlayFunctionParameterTypeHints = true,
				-- 		includeInlayVariableTypeHints = true,
				-- 		includeInlayPropertyDeclarationTypeHints = true,
				-- 		includeInlayFunctionLikeReturnTypeHints = true,
				-- 		includeInlayEnumMemberValueHints = true,
				-- 		importModuleSpecifierPreference = "non-relative",
				-- 	},
				-- },
			})

			lspconfig.tailwindcss.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.html.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { "vscode-html-language-server", "--stdio" },
				filetype = { "html", "ejs" },
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

			lspconfig.emmet_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
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

			lspconfig.cssls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { "vscode-css-language-server", "--stdio" },
				filetypes = { "css", "scss", "less" },
				root_dir = util.root_pattern("package.json", ".git") or vim.fn.expand("%p"),
				single_file_support = true,
				settings = {
					css = { validate = true },
				},
			})

			lspconfig.pyright.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetype = { "python" },
				cmd = { "pyright-langserver", "--stdio" },
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

			lspconfig.bashls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { "bash-language-server", "start" },
				cmd_env = { GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)" },
				filetypes = { "sh" },
			})

			lspconfig.marksman.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "markdown" },
				root_dir = util.root_pattern(".git", ".marksman.toml"),
			})

			lspconfig.jsonls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				root_dir = vim.F.if_nil(
					util.root_pattern({
						".git",
						".stylua.toml",
						"stylua.toml",
						".styluaignore",
						"selene.toml",
						".selene.toml",
					}),
					vim.loop.cwd()
				),
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
