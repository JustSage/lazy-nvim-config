return {
	"jose-elias-alvarez/null-ls.nvim",
	dependencies = { "mason.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local status, null_ls = pcall(require, "null-ls")
		if not status then
			return
		end

		local null_ls_utils = require("null-ls.utils")

		-- for conciseness
		local formatting = null_ls.builtins.formatting   -- to setup formatters
		local diagnostics = null_ls.builtins.diagnostics -- to setup linters
		local code_actions = null_ls.builtins.code_actions -- to setup linters
		local completion = null_ls.builtins.completion   -- to setup linters

		null_ls.setup({
			root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
			sources = {
				-- Code actions
				code_actions.eslint_d,
				code_actions.shellcheck,

				-- Spelling completion
				completion.spell.with({
					filetypes = {
						"markdown",
					},
				}),

				-- Web formatter & diagnostics
				diagnostics.eslint_d.with({
					command = "eslint_d",
					condition = function(utils)
						-- only enable if root has .eslintrc.js , .eslintrc.cjs or .eslintrc.json
						return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" })
					end,
				}),
				formatting.prettierd,

				-- Python formatter & diagnostics
				diagnostics.flake8.with({
					filetypes = { "python" },
					command = "flake8",
				}),

				formatting.black.with({
					filetypes = { "python" },
					command = "black",
				}),

				-- Lua
				formatting.stylua.with({
					filetypes = { "lua" },
				}),

				-- Shell
				-- formatting.shfmt,
				-- diagnostics.shellcheck,
				diagnostics.yamllint,
				formatting.yamlfmt,

				-- C/CPP formatter
				formatting.clang_format.with({
					filetypes = { "c", "cpp", "cs" },
					command = "clang-format",
				}),
				diagnostics.clang_check,
			},

			-- configure format on save
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					-- set format keymap
					vim.keymap.set("n", "<Leader>fm", function()
						vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
					end, { buffer = bufnr, desc = "[lsp] format" })

					-- format on save
					local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end

				if client.supports_method("textDocument/rangeFormatting") then
					-- set range format keymap
					vim.keymap.set("x", "<Leader>fm", function()
						vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
					end, { buffer = bufnr, desc = "[lsp] format" })
				end
			end,
		})
	end,
}
