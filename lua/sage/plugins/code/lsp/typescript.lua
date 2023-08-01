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
				local function on_attach(client, bufnr)
					if client.name == "tsserver" then
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
