return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	event = { "BufNewFile", "BufReadPost" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			textobjects = {
				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment region" },
						["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment region" },

						["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/field region" },
						["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/field region" },

						["af"] = { query = "@function.outer", desc = "Select outer part of a function region" },
						["if"] = { query = "@function.inner", desc = "Select inner part of a function region" },

						["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },

						["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional region" },
						["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional region" },

						["al"] = { query = "@loop.outer", desc = "Select outer part of a loop region" },
						["il"] = { query = "@loop.inner", desc = "Select inner part of a loop region" },

						["ab"] = { query = "@block.outer", desc = "Select outer part of a block region" }, -- overrides default text object block of parenthesis to parenthesis
						["ib"] = { query = "@block.inner", desc = "Select inner part of a block region" }, -- overrides default text object block of parenthesis to parenthesis
					},
					include_surrounding_whitespace = true,
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner", -- swap object under cursor with next
					},
					swap_previous = {
						["<leader>A"] = "@parameter.outer", -- swap object under cursor with previous
					},
				},
				move = {
					enable = true,
					set_jumps = true,

					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
						["]o"] = "@loop.*",
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
					goto_next = {
						["]i"] = "@conditional.inner",
					},
					goto_previous = {
						["[i"] = "@conditional.inner",
					},
				},
			},
		})
		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

		-- Repeat movement with ; and ,
		-- ensure ; goes forward and , goes backward regardless of the last direction
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

		-- vim way: ; goes to the direction you were moving.
		-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

		-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
	end,
}
