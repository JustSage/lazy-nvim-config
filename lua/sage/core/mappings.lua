---@diagnostic disable: param-type-mismatch, missing-parameter

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

-- Better undo - undos to punctuation
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", "!", "!<c-g>u")
map("i", "?", "?<c-g>u")

-- Use ESC to turn off search highlighting
map("n", "<Esc>", ":noh<CR>")

-- Harpoon
map("n", "<leader>m", function()
	require("harpoon.mark").add_file()
end)
map("n", "<C-m>,", function()
	require("harpoon.ui").toggle_quick_menu()
end)
map("n", "<C-m>", ":lua require'sage.core.functions'.nav_to_specific()<CR>")

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
	require("telescope.builtin").find_files({ hidden = true })
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
map("n", "<leader>fr", function()
	require("telescope").extensions.file_browser.file_browser({ hidden = true })
end)
map("n", "<leader>fp", function()
	require("telescope").extensions.projects.projects()
end, { silent = true })

-- Nvim Tree
map("n", "<leader>n", ":NvimTreeToggle<CR>")

-- Trouble
map("n", "<leader>xx", "<Cmd>TroubleToggle<CR>")
map("n", "<leader>xw", "<Cmd>TroubleToggle workspace_diagnostics<CR>")
map("n", "<leader>xd", "<Cmd>TroubleToggle document_diagnostics<CR>")
map("n", "<leader>xl", "<Cmd>TroubleToggle loclist<CR>")
map("n", "<leader>xq", "<Cmd>TroubleToggle quickfix<CR>")
map("n", "<leader>gR", "<Cmd>TroubleToggle lsp_references<CR>")

-- Lspsaga
map("n", "gj", "<Cmd>Lspsaga peek_definition<CR>")
map("n", "gt", "<Cmd>Lspsaga peek_type_definition<CR>")
map("n", "gT", "<Cmd>Lspsaga goto_type_definition<CR>")
map("n", "gd", "<Cmd>Lspsaga goto_definition<CR>")
map("n", "gr", "<Cmd>Lspsaga lsp_finder<CR>")
map("n", "K", "<Cmd>Lspsaga hover_doc ++quiet<CR>")
map("n", "rn", "<Cmd>Lspsaga rename<CR>")
map("n", "<leader>K", "<Cmd>Lspsaga hover_doc ++keep<CR>")
map("n", "<leader>rn", "<Cmd>Lspsaga rename ++project<CR>")
map("n", "<leader>o", "<Cmd>Lspsaga outline<CR>")
map("n", "<leader>sl", "<Cmd>Lspsaga show_line_diagnostics<CR>")
map("n", "<leader>sc", "<Cmd>Lspsaga show_cursor_diagnostics<CR>")
map("n", "<leader>sb", "<Cmd>Lspsaga show_buf_diagnostics<CR>")
map("v", "<leader>ca", "<Cmd>Lspsaga code_action<CR>")
map("n", "<leader>ca", "<Cmd>Lspsaga code_action<CR>")
map("n", "<Leader>ci", "<Cmd>Lspsaga incoming_calls<CR>")
map("n", "<Leader>co", "<Cmd>Lspsaga outgoing_calls<CR>")
map("n", "[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>")
map("n", "]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>")
-- Only jump to error
vim.keymap.set("n", "[e", function()
	require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
vim.keymap.set("n", "]e", function()
	require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })

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

-- Folding with nvim-ufo
map("n", "zR", function()
	require("ufo").openAllFolds()
end)
map("n", "zM", function()
	require("ufo").closeAllFolds()
end)
map("n", "zr", function()
	require("ufo").openFoldsExceptKinds()
end)
map("n", "zm", function()
	require("ufo").closeFoldsWith()
end) -- closeAllFolds == closeFoldsWith(0)
map("n", "K", function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		vim.lsp.buf.hover()
	end
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
map("n", "<leader>hr", ":Gitsigns reset_hunk<CR>")
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
