return {
	"jay-babu/mason-nvim-dap.nvim",
	event = "VeryLazy",
	config = function()
		local ok, mason_dap = pcall(require, "mason-nvim-dap")
		if not ok then
			return
		end

		mason_dap.setup({
			ensure_installed = { "python", "cppdbg", "bash", "javadbg", "javatest" },
			automatic_installation = true,
			automatic_setup = true,
			handlers = {},
		})
	end,
}
