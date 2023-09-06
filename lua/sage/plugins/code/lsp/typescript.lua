return {
	"neovim/nvim-lspconfig",
	ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "html" },
	dependencies = { "jose-elias-alvarez/typescript.nvim" },
	opts = {
		servers = {
			tsserver = {},
		},
		setup = {
			tsserver = function(_, opts)
				local augroup = vim.api.nvim_create_augroup("TypescriptAutoImport", {})
				local function on_attach(client, bufnr)
					if client.name == "tsserver" then
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							command = "TypescriptAddMissingImports",
						})
						vim.keymap.set("n", "<leader>mp", "<cmd>TypescriptAddMissingImports<CR>",
							{ buffer = bufnr, desc = "Add missing imports" })
						--stylua: ignore
						vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>",
							{ buffer = bufnr, desc = "OrganizeImorts" })
						--stylua: ignore
						vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>",
							{ buffer = bufnr, desc = "Rename File" })
					end
				end
				require("typescript").setup({ server = { tsserver = { on_attach = on_attach, opts } } })
				return true
			end,
		},
	},
}
