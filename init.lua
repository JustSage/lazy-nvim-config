local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("sage.core")
-- load and setup lazy so that it can start managing plugins
require("lazy").setup({
	spec = {
		{ import = "sage.plugins" },
		{ import = "sage.plugins.ui.general" },
		{ import = "sage.plugins.ui.colors" },
		{ import = "sage.plugins.ui.navigation" },
		{ import = "sage.plugins.ui.integration" },
		{ import = "sage.plugins.code.lsp" },
		{ import = "sage.plugins.code.completion" },
		{ import = "sage.plugins.code.debug-test" },
		{ import = "sage.plugins.code.database" },
		{ import = "sage.plugins.git" },
	},
	lockfile = vim.fn.stdpath("config") .. "/lock.json",
	root = vim.fn.fnamemodify(lazypath, ":h"),
	concurrency = 50,
	defaults = { lazy = true },
	install = {
		missing = true,
		colorscheme = { "catppuccin" },
	},
	ui = {
		size = { width = 0.8, height = 0.8 },
		border = "solid",
		icons = {
			cmd = " ",
			config = "",
			event = "",
			ft = " ",
			init = " ",
			import = " ",
			keys = " ",
			lazy = "鈴 ",
			loaded = "●",
			not_loaded = "○",
			plugin = " ",
			runtime = " ",
			source = " ",
			start = "",
			task = "✔ ",
			list = { "●", "➜", "★", "‒" },
		},
		throttle = 20,
	},
	diff = {
		cmd = "diffview.nvim",
	},
	checker = {
		enabled = false,
		concurrency = 50,
		notify = true,
		frequency = 3600,
	},
	change_detection = {
		enabled = true,
		notify = true,
	},
	performance = {
		cache = {
			enabled = true,
			path = vim.fn.stdpath("cache") .. "/lazy/cache",
			ttl = 3600 * 24 * 5,
			disable_events = { "VimEnter", "BufReadPre", "UIEnter" },
		},
		reset_packpath = true,
		rtp = {
			disabled_plugins = {
				"netrwPlugin",
				"netrwSettings",
				"netrwFileHandlers",
				"netrw",
				"matchparen",
				"2html_plugin",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"logipat",
				"matchit",
				"tar",
				"tarPlugin",
				"rrhelper",
				"spellfile_plugin",
				"vimball",
				"vimballPlugin",
				"zip",
				"zipPlugin",
				"tutor",
				"rplugin",
				"syntax",
				"synmenu",
				"optwin",
				"compiler",
				"bugreport",
				"tutor_mode_plugin",
				"fzf",
				"sleuth",
			},
		},
	},
	readme = {
		root = vim.fn.stdpath("state") .. "/lazy/readme",
		files = { "README.md", "lua/**/README.md", ".github/README.md" },
		skip_if_doc_exists = true,
	},
})
