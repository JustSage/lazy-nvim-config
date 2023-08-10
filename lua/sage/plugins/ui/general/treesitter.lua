return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			init = function()
				-- PERF: no need to load the plugin, if we only need its queries for mini.ai
				local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
				local opts = require("lazy.core.plugin").values(plugin, "opts", false)
				local enabled = false
				if opts.textobjects then
					for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
						if opts.textobjects[mod] and opts.textobjects[mod].enable then
							enabled = true
							break
						end
					end
				end
				if not enabled then
					require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
				end
			end,
		},
	},
	config = function()
		local present, ts_config = pcall(require, "nvim-treesitter.configs")
		if not present then
			return
		end

		require("orgmode").setup_ts_grammar()

		ts_config.setup({
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"css",
				"help",
				"html",
				"java",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"org",
				"python",
				"query",
				"regex",
				"scss",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"http",
			},
			highlight = {
				enable = true,
				use_languagetree = true,
				additional_vim_regex_highlighting = { "org" },
			},
			rainbow = {
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
				config = {
					typescript = { __default = "// %s", __multiline = "/* %s */" },
					css = "/* %s */",
					scss = { __default = "// %s", __multiline = "/* %s */" },
					php = { __default = "// %s", __multiline = "/* %s */" },
					html = "<!-- %s -->",
					svelte = "<!-- %s -->",
					vue = "<!-- %s -->",
					astro = "<!-- %s -->",
					handlebars = "{{! %s }}",
					glimmer = "{{! %s }}",
					graphql = "# %s",
					lua = { __default = "-- %s", __multiline = "--[[ %s ]]" },
					vim = '" %s',
					twig = "{# %s #}",
					-- Languages that can have multiple types of comments
					tsx = {
						__default = "// %s",
						__multiline = "/* %s */",
						jsx_element = "{/* %s */}",
						jsx_fragment = "{/* %s */}",
						jsx_attribute = { __default = "// %s", __multiline = "/* %s */" },
						comment = { __default = "// %s", __multiline = "/* %s */" },
						call_expression = { __default = "// %s", __multiline = "/* %s */" },
						statement_block = { __default = "// %s", __multiline = "/* %s */" },
						spread_element = { __default = "// %s", __multiline = "/* %s */" },
					},
					javascript = {
						__default = "// %s",
						__multiline = "/* %s */",
						jsx_element = "{/* %s */}",
						jsx_fragment = "{/* %s */}",
						jsx_attribute = { __default = "// %s", __multiline = "/* %s */" },
						comment = { __default = "// %s", __multiline = "/* %s */" },
						call_expression = { __default = "// %s", __multiline = "/* %s */" },
						statement_block = { __default = "// %s", __multiline = "/* %s */" },
						spread_element = { __default = "// %s", __multiline = "/* %s */" },
					},
				},
			},
			querylinter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
			textobjects = {
				select = {
					enable = true,
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						-- You can optionally set descriptions to the mappings (used in the desc parameter of
						-- nvim_buf_set_keymap) which plugins like which-key display
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
						-- You can also use captures from other query groups like `locals.scm`
						["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
					},
					-- You can choose the select mode (default is charwise 'v')
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap`.
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * selection_mode: eg 'v'
					-- and should return true of false
					include_surrounding_whitespace = true,
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = { query = "@class.outer", desc = "Next class start" },
						--
						-- You can use regex matching and/or pass a list in a "query" key to group multiple queries.
						["]o"] = "@loop.*",
						-- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
						--
						-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
						-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
						["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
						["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
					-- Below will go to either the start or the end, whichever is closer.
					-- Use if you want more granular movements
					-- Make it even more gradual by adding multiple queries and regex.
					-- goto_next = {
					-- 			["]d"] = "@conditional.outer",
					-- },
					-- goto_previous = {
					-- 			["[d"] = "@conditional.outer",
					-- },
				},
				lsp_interop = {
					enable = true,
					border = "solid",
					floating_preview_opts = {},
					peek_definition_code = {
						["<leader>df"] = "@function.outer",
						["<leader>dF"] = "@class.outer",
					},
				},
			},
		})
	end,
}
