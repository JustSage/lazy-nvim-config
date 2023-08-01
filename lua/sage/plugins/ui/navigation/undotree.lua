return {
	{
		"mbbill/undotree",
		event = { "BufReadPost", "BufNewFile" },
		keys = { "n", "<leader>u" },
		config = function()
			vim.g.undotree_WindowLayout = 4
			vim.g.undotree_DiffpanelHeight = 20
		end,
	},
}
