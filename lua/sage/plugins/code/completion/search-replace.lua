return {
	"windwp/nvim-spectre",
	event = "VeryLazy",
	-- stylua: ignore
	config = function()
		require("spectre").setup({
			open_cmd = "new",
			mapping = {
				['open_in_vsplit'] = {
					map = "<c-v>",
					cmd = "<cmd>lua vim.cmd('vsplit ' .. require('spectre.actions').get_current_entry().filename)<CR>",
					desc = "open in vertical split"
				},
				['open_in_split'] = {
					map = "<c-x>",
					cmd = "<cmd>lua vim.cmd('split ' .. require('spectre.actions').get_current_entry().filename)<CR>",
					desc = "open in horizontal split"
				},
			}
		})
	end,
	key = {
		{
			"<leader>sr",
			function()
				require("spectre").open()
			end,
			desc = "Replace in files (Spectre)",
		},
	},
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
	},
}
