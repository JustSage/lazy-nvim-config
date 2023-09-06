local cmd = vim.cmd

local function augroup(name)
	return vim.api.nvim_create_augroup(name, { clear = true })
end

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank({ on_visual = true, timeout = 150 })
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

--vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
--	group = augroup("ejs"),
--	callback = function()
--		vim.cmd("*.ejs set filetype=html")
--	end,
--})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"qf",
		"help",
		"man",
		"notify",
		"lspinfo",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"PlenaryTestPopup",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown", "org" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
	end,
})

cmd([[cnoremap <expr> / wildmenumode() ? "\<C-Y>" : "/"]])
cmd([[cnoremap <expr> * getcmdline() =~ '.*\*\*$' ? '/*' : '*']])
cmd([[cnoreabbr <expr> %% fnameescape(expand('%:p'))]])

-- neotest commands
cmd([[
    command! NeotestSummary lua require("neotest").summary.toggle()
    command! NeotestFile lua require("neotest").run.run(vim.fn.expand("%"))
    command! Neotest lua require("neotest").run.run(vim.fn.getcwd())
    command! NeotestNearest lua require("neotest").run.run()
    command! NeotestDebug lua require("neotest").run.run({ strategy = "dap" })
    command! NeotestAttach lua require("neotest").run.attach()
]])
-- no numbers or relative numbers on term windows.
cmd([[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]])
-- turn off paste mode when leaving insert.
cmd([[autocmd InsertLeave * set nopaste]])
-- set file type to terminals
cmd([[ au TermOpen term://* setfiletype Terminal ]])
-- initiates new java class with file name when opening a new file
cmd([[ au BufNewFile *.java exe "normal opublic class " . expand('%:t:r') "\n{\n\n}"]])
