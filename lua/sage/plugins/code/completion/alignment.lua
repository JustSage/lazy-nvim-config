return {
	{
		"Wansmer/treesj",
		lazy = true,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({
				cursor_hevariour = "hold",
				use_default_keymaps = false,
				dot_repeat = true,
			})
		end,
	},
}
