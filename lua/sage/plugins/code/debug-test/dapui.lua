return {
	"rcarriga/nvim-dap-ui",
	keys = {
		{
			"<leader>du",
			function()
				require("dapui").toggle({})
			end,
			desc = "Dap UI",
		},
		{
			"<leader>de",
			function()
				require("dapui").eval()
			end,
			desc = "Eval",
			mode = { "n", "v" },
		},
	},
	event = "VeryLazy",
	dependencies = { "mfussenegger/nvim-dap" },
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local icons = require("sage.util.icons").dap

		for name, icon in pairs(icons) do
			name = "Dap" .. name
			vim.fn.sign_define(name, { text = icon, texthl = "ErrorMsg", numhl = "ErrorMsg", linehl = "ErrorMsg" })
		end

		require("dapui").setup()

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		vim.keymap.set("n", "<leader>du", function()
			dapui.toggle()
		end, {})
	end,
}
