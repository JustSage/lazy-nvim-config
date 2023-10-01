return {
	"NvChad/nvim-colorizer.lua",
	opts = {
		user_default_options = {
			tailwind = true,
		},
	},
	event = { "BufReadPre", "BufNewFile" },
	config = true,
}
