return {
	"glepnir/lspsaga.nvim",
	branch = "main",
	event = "BufReadPost",
	config = function()
		local status, saga = pcall(require, "lspsaga")
		if not status then
			return
		end

		saga.setup({
			ui = {
				-- currently only round theme
				theme = "round",
				-- border type can be single,double,rounded,solid,shadow.
				border = "rounded",
				winblend = 0,
				expand = "",
				collapse = "",
				preview = " ",
				code_action = "💡",
				diagnostic = "🐞",
				incoming = " ",
				outgoing = " ",
				colors = require("catppuccin.groups.integrations.lsp_saga").custom_colors(),
				kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
			},
			preview = {
				lines_above = 0,
				lines_below = 0,
			},
			lightbulb = {
				cache_code_action = false,
				virtual_text = false,
				sign = true,
			},
			code_action = {
				keys = {
					quit = "<ESC>",
					exec = "<CR>",
				},
				extend_gitsigns = true,
			},
			diagnostic = {
				on_insert = false,
			},
			symbol_in_winbar = {
				enable = false,
			},
		})
	end,
}
