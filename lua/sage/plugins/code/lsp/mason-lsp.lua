return {
	"williamboman/mason-lspconfig.nvim",
	config = function()
		local servers = require("sage.util.servers")
		require("mason-lspconfig").setup({
			ensure_installed = servers,
			automatic_installation = true,
		})
	end,
}
