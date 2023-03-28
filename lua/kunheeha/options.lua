-- File encoding
vim.opt.fileencoding = "utf-8"

-- Backup and Swap
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

-- highlight all matches on previous search pattern
vim.opt.hlsearch = true

-- ignore case in search pattern
vim.opt.ignorecase = true

vim.opt.showtabline = 2			-- always show tabs
vim.opt.smartcase = true

-- Indentation
vim.opt.smartindent = true
vim.opt.expandtab = true		-- convert tabs to spaces
vim.opt.tabstop = 2			-- insert 2 spaces for a tab
vim.opt.shiftwidth = 2			-- number of spaces for each indentation

-- Split direction
vim.opt.splitbelow = true
vim.opt.splitright = true

-- vim.opt.termguicolors = true
vim.opt.timeoutlen = 1000		-- time to wait for mapped sequence to complete (in milliseconds)
vim.opt.updatetime = 300		-- faster completion
vim.opt.undofile = true			-- persistent undo

-- set nu rnu
vim.opt.number = true
vim.opt.relativenumber = true

-- Scrolloff
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Wrapping
vim.opt.wrap = true			-- long line as one line
vim.opt.linebreak = true --avoid wrapping in middle of word

vim.opt.numberwidth = 4			-- number column width (default=4)
vim.opt.signcolumn = "yes"		-- show sign column
vim.opt.mouse = "a"			-- make vim clickable
vim.opt.clipboard = "unnamedplus"	-- system clipboard
