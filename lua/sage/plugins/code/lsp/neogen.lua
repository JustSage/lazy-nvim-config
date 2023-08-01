return {
	"danymat/neogen",
	version = "*",
	lazy = true,
	config = function()
		require("neogen").setup({
			enabled = true,
			input_after_comment = true,
			enable_placeholders = true,
			snippet_engine = "luasnip",
			placeholders_text = {
						["description"] = "[TODO:description]",
						["tparam"] = "[TODO:tparam]",
						["parameter"] = "[TODO:parameter]",
						["return"] = "[TODO:return]",
						["class"] = "[TODO:class]",
						["throw"] = "[TODO:throw]",
						["varargs"] = "[TODO:varargs]",
						["type"] = "[TODO:type]",
						["attribute"] = "[TODO:attribute]",
						["args"] = "[TODO:args]",
						["kwargs"] = "[TODO:kwargs]",
			},
		})
	end,
	key = {
		{
			"<leader>'",
			function()
				require("neogen").generate()
			end,
			desc = "Generate Documentation",
		},
	},
}
