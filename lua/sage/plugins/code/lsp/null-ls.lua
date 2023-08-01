return {
	"jose-elias-alvarez/null-ls.nvim",
	dependencies = { "mason.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local status, null_ls = pcall(require, "null-ls")
		if not status then
			return
		end

		local builtins = null_ls.builtins

		null_ls.setup({
			sources = {
				-- Code actions
				null_ls.builtins.code_actions.eslint_d,
				null_ls.builtins.code_actions.shellcheck,
				null_ls.builtins.completion.spell.with({
					filetypes = {
						"markdown",
					},
				}),

				-- Web formatter & diagnostics
				builtins.formatting.prettier.with({
					filetypes = {
						"html",
						-- "json",
						"css",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					},
				}),

				builtins.diagnostics.eslint_d.with({
					diagnostics_format = "[eslint] #{m}\n(#{c})",
					command = "eslint_d",
					args = { "-f", "json", "--stdin", "--stdin-filename", "$FILENAME" },
				}),

				-- Python formatter & diagnostics
				builtins.diagnostics.flake8.with({
					filetypes = { "python" },
					command = "flake8",
					args = { "--stdin-display-name", "$FILENAME", "-" },
				}),

				builtins.formatting.black.with({
					filetypes = { "python" },
					command = "black",
					args = { "--quiet", "--fast", "-" },
				}),

				-- C/CPP formatter
				builtins.formatting.clang_format.with({
					filetypes = { "c", "cpp", "cs" },
					command = "clang-format",
				}),

				-- Lua
				builtins.formatting.stylua.with({
					filetypes = { "lua" },
				}),

				-- Shell
				builtins.formatting.shfmt,
				builtins.diagnostics.shellcheck.with({
					diagnostics_format = "#{m} [#{c}]",
				}),
			},
			-- behaviour
			on_attach = function(client, bufnr)
				if client.name == "html" then
					client.server_capabilities.documentFormattingProvider = false
				end

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
								-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
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
