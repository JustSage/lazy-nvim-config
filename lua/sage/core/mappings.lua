local function map(mode, lhs, rhs, opts) -- keybinding convention
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Disable command history list on q:
map("n", "q:", "<nop>")
map("n", "Q", "<nop>")

-- stylua: ignore start
map("x", "<leader>p", "\"_dP")
map("n", "<leader>y", "\"+y")
map("v", "<leader>y", "\"+y")
map("n", "<leader>Y", "\"+Y")
map("v", "<leader>d", "\"_d")
map("n", "<leader>d", "\"_d")
-- stylua: ignore end

map("n", "<C-n>", ":cnext<CR>zz")
map("n", "<C-p>", ":cprev<CR>zz")
map("n", "<C-n>", ":lnext<CR>zz")
map("n", "<C-p>", ":lprev<CR>zz")

-- Cursor standstill
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Moving lines faster with J & K
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "<leader>j", ":m .+1<CR>==")
map("n", "<leader>k", ":m .-2<CR>==")

map("n", "<leader>/", ":%s/<C-r><C-w>//gI<Left><Left><Left>", { silent = false })
map("n", "<leader>?", ":%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>", { silent = false })
map("n", "<leader>ch", ":!chmod +x %<CR>")

-- Toggle Tailwind LSP
map("n", "<leader>lt", function()
	local toggler = require("sage.util.lsp-toggler")
	local tailwind_id = toggler.get_lsp_id("tailwindcss")
	if tailwind_id == 0 then
		toggler.start_server("tailwindcss")
	else
		toggler.stop_server(tailwind_id)
	end
end, { desc = "Toggle Tailwind LSP Active / Inactive" })

-- Better undo - undos to punctuation
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", "!", "!<c-g>u")
map("i", "?", "?<c-g>u")

-- Use ESC to turn off search highlighting
map("n", "<Esc>", ":noh<CR>")

-- Fugitive
map("n", "<leader>gs", ":Git<CR>")
map("n", "<leader>gb", ":GBrowse<CR>")
map("n", "<leader>gv", ":Gvdiffsplit!<CR>")
map("n", "<leader>gf", ":diffget //2<CR>")
map("n", "<leader>gh", ":diffget //3<CR>")

map("n", "<leader>'", ":lua require('neogen').generate()<CR>")

map("n", "<leader>ut", "<Cmd>UndotreeToggle<CR>")

-- Telescope

map("n", "<leader>rc", function()
	require("telescope.builtin").find_files({ cwd = "~/.config/", prompt_title = "< Dotfiles >", hidden = true })
end)

map("n", "<leader>fs", function()
	require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
end)
map("n", "<leader>fo", function()
	require("telescope.builtin").oldfiles()
end)
map("n", "<leader>gc", function()
	require("telescope.builtin").git_commits()
end)
map("n", "<leader>ff", function()
	require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
end)
map("n", "<leader>fb", function()
	require("telescope.builtin").buffers()
end)
map("n", "<leader>fh", function()
	require("telescope.builtin").help_tags()
end)
map("n", "<leader>fw", function()
	require("telescope.builtin").grep_string()
end)
map("n", "<C-g><C-g>", function()
	require("telescope.builtin").git_files()
end)
map("n", "<leader>fg", function()
	require("telescope.builtin").live_grep({ hidden = true })
end)
map("n", "<leader>fG", function()
	require("telescope").extensions.live_grep_args.live_grep_args({ prompt_title = " < Live Rip Grep >" })
end)

-- Nvim Tree
map("n", "<leader>n", ":NvimTreeToggle<CR>")

-- Trouble
map("n", "<leader>xx", "<Cmd>TroubleToggle<CR>")
map("n", "<leader>xw", "<Cmd>TroubleToggle workspace_diagnostics<CR>")
map("n", "<leader>xd", "<Cmd>TroubleToggle document_diagnostics<CR>")
map("n", "<leader>xl", "<Cmd>TroubleToggle loclist<CR>")
map("n", "<leader>xq", "<Cmd>TroubleToggle quickfix<CR>")

-- DAP
map("n", "<leader>dc", function()
	require("dap").continue()
end)
map("n", "<leader>dt", function()
	require("dap").terminate()
end)
map("n", "<leader>dn", function()
	require("dap").step_over()
end)
map("n", "<leader>di", function()
	require("dap").step_into()
end)
map("n", "<leader>do", function()
	require("dap").step_out()
end)
map("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end)
map("n", "<leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
map("n", "<leader>lp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
map("n", "<leader>dr", function()
	require("dap").repl.toggle()
end)

map("n", "<leader>sr", function()
	require("spectre").open()
end, { desc = "Replace in files (Spectre)" })

-- GIT SIGNS
map("n", "]h", "&diff ? ']h' : ':Gitsigns next_hunk<CR>'", { expr = true })
map("n", "[h", "&diff ? '[h' : ':Gitsigns prev_hunk<CR>'", { expr = true })
map("n", "<leader>hs", ":Gitsigns stage_hunk<CR>")
map("v", "<leader>hs", ":Gitsigns stage_hunk<CR>")
map("n", "<leader>hS", ":Gitsigns stage_buffer<CR>")
map("v", "<leader>hr", ":Gitsigns reset_hunk<CR>")
map("n", "<leader>hR", ":Gitsigns reset_buffer<CR>")
map("n", "<leader>hu", ":Gitsigns undo_stage_hunk<CR>")
map("n", "<leader>hp", ":Gitsigns preview_hunk<CR>")
map("n", "<leader>hd", ":Gitsigns diffthis<CR>")
map("n", "<leader>hb", ":lua require'gitsigns'.blame_line{full=true}<CR>")
map("n", "<leader>hdd", ":lua require'gitsigns'.diffthis('~')<CR>")
map("n", "<leader>tb", ":Gitsigns toggle_current_line_blame<CR>")
map("n", "<leader>td", ":Gitsigns toggle_deleted<CR>")

map("n", "<leader>tf", ":NeotestNearest<CR>")
-- Dadbod

map("n", ",db", ":DBUIToggle<CR>")
map("n", ",dbb", ":DBUIFindBuffer<CR>")
map("n", ",dbr", ":DBUIRenameBuffer<CR>")
map("n", ",dbq", ":DBUILastQueryInfo<CR>")

map("n", "<C-s>", ":SnipRun<CR>")
map("v", "<C-s>", ":SnipRun<CR>")

-- Treesj (split/join)
map("n", "<leader>ss", function()
	require("treesj").split()
end)
map("n", "<leader>sj", function()
	require("treesj").join()
end)
