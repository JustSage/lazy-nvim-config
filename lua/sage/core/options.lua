-------------------- HELPERS -------------------------------
local g = vim.g                             -- a table to set global variables
local o = vim.opt                           -- a table to set option variables
local bo = vim.bo                           -- a table to set buffer specific option variables
local wo = vim.wo                           -- a table to set window specific option variables
-----------------------------------------------------------------
bo.autoindent = true                        -- figures out how to indent.
bo.expandtab = true
bo.smartindent = true                       -- figures out when to indent.
o.autoread = true                           -- read file when switching buffer.
o.autowrite = true                          -- write file when switching buffer.
o.backup = false                            -- disable backupfile generator.
o.clipboard = ""                            -- clipboard settings for my os (darwin)
o.cmdheight = 1                             -- command prompt height.
o.colorcolumn = "100"
o.completeopt = "menuone,noinsert,noselect" -- complete option menu.
o.cursorline = false                        -- highlights the line on cursor.
o.diffopt = "vertical"                      -- opens git diff in vertical split.
o.encoding = "utf-8"                        -- encoding settings.
o.errorbells = false                        -- avoids screen flashes.
o.fileencodings = "utf-8"                   -- encoding buffer settings.
o.hidden = true                             -- navigate to other buffers without saving current.
o.hlsearch = true                           -- highlights search
o.ignorecase = true                         -- the case of normal letters is ignored.
o.inccommand = "split"                      -- incremental substitution
o.incsearch = true                          -- incremental search.
o.keywordprg = ":help"                      -- open help with 'K'.
o.laststatus = 3
o.lazyredraw = false                        -- good performance settings.
o.mouse = "a"                               -- enable mouse
o.scrolloff = 10                            -- keep 'n' lines visible when scrolling.
o.showcmd = true                            -- shows command on the right side of the command prompt.
o.showmode = false
o.smartcase = true                          -- overrides ignorecase if search includes uppercase letters.
o.spelllang = "en_us"                       -- set spelling to english
o.splitbelow = true                         -- horizontal splits below.
o.splitright = true                         -- vertical splits to the right.
o.swapfile = false                          -- disable swapfile generator.
o.termguicolors = true                      -- use the terminal gui colors.
o.timeoutlen = 350                          -- timeout before key refresh.
o.ttyfast = true
o.undofile = true                           -- disable undofile generator.
o.updatetime = 50                           -- update interval for gitsigns.
wo.number = true                            -- show row current line.
wo.relativenumber = true                    -- show relative numbers above/below current row.
o.foldenable = true

o.path:append({ "**" }) -- file paths, searching and ignores
o.wildignore:append({
	"*/node_modules/*",
	"*.pyc",
	"*.DS_Store",
	"*.jpg",
	"*.bmp",
	"*.gif",
	"*.png",
	"*.jpeg",
	"versions/*",
	"cache/*",
})

o.suffixesadd:append({
	".html",
	".js",
	".es",
	".jsx",
	".json",
	".css",
	".sass",
	".py",
	".md",
	".java",
	".c",
	".cpp",
})

vim.cmd([[setlocal formatoptions-=cro]]) -- disable comment continouation in next line
vim.opt.undodir = vim.fn.expand("$XDG_CACHE_HOME/nvim/undodir/")
o.dictionary = "/usr/share/dict/words"

o.signcolumn = "yes"
wo.wrap = false

-- providers
g.python3_host_prog = "$PYENV_ROOT/shims/python"
g.python2_host_prog = "/usr/bin/python2"

g.markdown_recommended_style = 0

--vim.env.GIT_WORK_TREE = vim.fn.expand("$HOME")
--vim.env.GIT_DIR = vim.fn.expand("$HOME/.cfg")
