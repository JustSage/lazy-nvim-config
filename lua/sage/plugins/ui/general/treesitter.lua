return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local present, ts_config = pcall(require, "nvim-treesitter.configs")
		if not present then
			return
		end

		ts_config.setup({
			ensure_installed = {
				"typescript",
				"javascript",
				"tsx",
				"json",
				"bash",
				"help",
				"css",
				"html",
				"lua",
				"markdown",
				"markdown_inline",
				"org",
				"python",
				"query",
				"regex",
				"sql",
				"scss",
				"toml",
				"vim",
				"http",
				"c",
				"cpp",
			},
			highlight = {
				enable = true,
			},
			matchup = {
				enable = true,
			},
			autotag = {
				enable = true,
			},
			indent = {
				enable = true,
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			querylinter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
		})
	end,
}
