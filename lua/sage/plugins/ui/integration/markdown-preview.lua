return {
	{
		"iamcco/markdown-preview.nvim",
		event = "VeryLazy",
		cmd = "MarkdownPreview",
		ft = "markdown",
		build = [[sh -c 'cd app && yarn install']],
	},
}
