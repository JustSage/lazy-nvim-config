return {
	"jay-babu/mason-nvim-dap.nvim",
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap",
	},
	config = function()
		local ok, mason_dap = pcall(require, "mason-nvim-dap")
		if not ok then
			return
		end

		local debuggers = require("sage.util.debuggers").mason

		mason_dap.setup({
			ensure_installed = debuggers,
			automatic_installation = true,
		})
	end,
}
