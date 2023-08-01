return {
	"jay-babu/mason-null-ls.nvim",
	event = "VeryLazy",
	config = function()
		local mason_null = require("mason-null-ls")
		local checkers = require("sage.util.checkers")
		mason_null.setup({
			ensure_installed = checkers,
			automatic_installation = true,
			automatic_setup = true,
			handlers = {},
		})
	end,
}
