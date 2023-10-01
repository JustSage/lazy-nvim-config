return {
	"nvim-tree/nvim-web-devicons",
	lazy = true,
	config = function()
		require("nvim-web-devicons").setup({
			override_by_filename = {
				["Dockerfile"] = {
					icon = "",
					color = "#458ee6",
					cterm_color = "68",
					name = "Dockerfile",
				},

				["docker-compose.yaml"] = {
					icon = "",
					color = "#458ee6",
					cterm_color = "68",
					name = "Dockerfile",
				},

				[".dockerignore"] = {
					icon = "",
					color = "#458ee6",
					cterm_color = "68",
					name = "Dockerfile",
				},
			},
		})
	end,
}
