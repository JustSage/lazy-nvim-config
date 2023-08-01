return {
	{
		"andweeb/presence.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local present, presence = pcall(require, "presence")
			if present then
				presence:setup({
					enable_line_number = true,
					main_image = "file",
					neovim_image_text = "Don't memorize what you can search for - Albert Einstein",
				})
			end
		end,
	},
}
