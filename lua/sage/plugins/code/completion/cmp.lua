return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		event = "InsertCharPre",
		build = "make install_jsregexp",
		config = function()
			local luasnip = require("luasnip")
			luasnip.config.set_config({
				history = true,
				updateevents = "TextChanged,TextChangedI",
			})

			-- Loading self made vscode snippets located in runtimepath
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = { "./snippets" },
			})
			-- Loading snippets from friendly-snippets
			require("luasnip.loaders.from_vscode").lazy_load()
			-- Loading snipmate snippets located in runtimepath
			require("luasnip.loaders.from_snipmate").lazy_load()

			luasnip.filetype_extend("typescript", { "javascript" })
		end,
	},
	{ "andymass/vim-matchup", event = "VeryLazy" },
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"bydlw98/cmp-env",
			"windwp/nvim-autopairs",
			"saadparwaiz1/cmp_luasnip",
			-- "dcampos/cmp-emmet-vim",
			{ "jackieaskins/cmp-emmet", build = "npm run release" },
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			require("nvim-autopairs").setup({})

			cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

			-- nvim-cmp setup
			cmp.setup({
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				completion = {
					completeopt = "menu,menuone,noinsert,noselect",
				},
				formatting = {
					format = function(entry, vim_item)
						-- load lspkind icons
						local icons = require("sage.util.icons").kinds
						vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							nvim_lua = "[Lua]",
							luasnip = "[Snip]",
							emmet = "[Emmet]",
							buffer = "[BUF]",
							latex_symbols = "[Latex]",
							env = "[ENV]",
						})[entry.source.name]
						vim_item.dup = ({
							nvim_lsp = 0,
							nvim_lua = 0,
							buffer = 0,
							cmdline = 0,
							path = 0,
						})[entry.source.name] or 0
						return vim_item
					end,
				},
				mapping = cmp.mapping.preset.insert({
					[","] = cmp.mapping(function(fallback)
						fallback()
					end), -- emmet support
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-u>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(cmp.CompleteParams),
					["<C-c>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
							-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
							-- they way you will only jump inside the snippet region
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif require("sage.core.functions").has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				preselect = cmp.PreselectMode.None,
				sources = {
					{ name = "luasnip",                option = { show_autosnippets = false } },
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "nvim_lsp_signature_help" },
					{
						name = "env",
						option = {
							eval_on_confirm = false,
							show_documentation_window = true,
							item_kind = cmp.lsp.CompletionItemKind.Constructor,
						},
						group_index = 2,
					},
					{ name = "path" },
					{ name = "buffer" },
					{ name = "emmet", option = { max_item_count = 2} },
					-- { name = "vim-dadbod-completion" },
					-- { name = "orgmode" },
				},
				enabled = function()
					-- disable completion on prompt buffers
					local buftype = vim.api.nvim_buf_get_option(0, "buftype")
					if buftype == "prompt" then
						return false
					end
					-- disable completion in comments
					local context = require("cmp.config.context")
					-- keep command mode completion enabled when cursor is in a comment
					if vim.api.nvim_get_mode().mode == "c" then
						return true
					else
						return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
					end
				end,
			})
			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})
		end,
	},
}
