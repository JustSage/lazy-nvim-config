return {
	{
		"echasnovski/mini.indentscope",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("mini.indentscope").setup({
				vim.api.nvim_create_autocmd("FileType", {
					pattern = { "help", "alpha", "nvim-tree", "Trouble", "mason" },
					callback = function()
						vim.b.miniindentscope_disable = true
					end,
				}),
				options = {
					try_as_border = true,
				},
			})
			vim.api.nvim_set_hl(0, "MiniIndentScopeSymbol", { fg = "#7B82AE" })
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local present, blankline = pcall(require, "indent_blankline")
			if not present then
				return
			end
			local opts = {
				indentLine_enabled = 1,
				filetype_exclude = {
					"help",
					"terminal",
					"packer",
					"lspinfo",
					"TelescopePrompt",
					"TelescopeResults",
					"Trouble",
					"mason",
					"alpha",
				},
				buftype_exclude = { "terminal" },
				show_first_indent_level = true,
				show_trailing_blankline_indent = false,
				show_current_context = false,
				show_current_context_start = false,
				space_char_blankline = " ",
			}
			blankline.setup(opts)
		end,
	},
}
