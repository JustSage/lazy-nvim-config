return {
	"mfussenegger/nvim-dap",
	keys = { "n", "<leader>b" },
	dependencies = {
		{ "theHamsta/nvim-dap-virtual-text" },
	},
	config = function()
		local dap = require("dap")
		local dap_js = require("sage.util.dap-config.javascript")
		local dap_python = require("sage.util.dap-config.python")

		dap_js.setup(dap)
		dap_python.setup(dap)
	end,
}
