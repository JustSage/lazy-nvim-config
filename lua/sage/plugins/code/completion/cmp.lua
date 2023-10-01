return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			event = "InsertCharPre",
			build = "make install_jsregexp",
			dependencies = { "rafamadriz/friendly-snippets" },
		},
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"bydlw98/cmp-env",
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		-- Luasnip configurations
		luasnip.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
		})

		-- Loading self made vscode snippets located in runtimepath
		require("luasnip.loaders.from_vscode").lazy_load({
			paths = { "./snippets" },
		})
		-- Loading snipmate snippets located in runtimepath
		require("luasnip.loaders.from_snipmate").lazy_load()

		-- Loading snippets from friendly-snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Extending filetypes
		luasnip.filetype_extend("typescript", { "javascript", "javascriptreact" })
		luasnip.filetype_extend("javascript", { "javascriptreact", "html" })

		-- nvim-cmp setup
		cmp.setup({
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = {
				completeopt = "menu,menuone,noinsert,noselect",
			},
			formatting = {
				format = function(entry, vim_item)
					local icons = require("sage.util.icons").kinds
					-- load lspkind icons
					vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						nvim_lua = "[Lua]",
						luasnip = "[Snip]",
						emmet = "[Emmet]",
						buffer = "[BUF]",
						env = "[ENV]",
					})[entry.source.name]
					vim_item.dup = ({
						nvim_lsp = 0,
						nvim_lua = 0,
						luasnip = 0,
						buffer = 0,
						cmdline = 0,
						emmet = 0,
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
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
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
			performance = {
				trigger_debounce_time = 500,
				throttle = 550,
				fetching_timeout = 80,
			},
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
				{ name = "buffer" },
				{ name = "path" },
			},
			sorting = {
				priority_weight = 2,
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,
					-- function(entry1, entry2)
					-- 	if vim.bo.filetype == "css" then
					-- 		local is_value1 = entry1.completion_item.kind == cmp.lsp.CompletionItemKind.Value
					-- 		local is_value2 = entry2.completion_item.kind == cmp.lsp.CompletionItemKind.Value
					--
					-- 		return is_value1 and not is_value2
					-- 	end
					-- end,
					cmp.config.compare.sort_text,
					cmp.config.compare.kind,
					cmp.config.compare.length,
				},
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
}
