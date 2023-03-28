-- Leader key --
vim.g.mapleader = ","

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- Escape key --
keymap("i", "ii", "<Esc>", opts)
keymap("v", "ii", "<Esc>", opts)

---------------------
-- Normal Mode (n) --
---------------------

-- Default file explorer
-- keymap("n", "<leader>f", vim.cmd.Ex)

-- Write
keymap("n", "<leader>w", vim.cmd.w, opts)

-- Resize window
keymap("n", "<Up>", ":resize +2<CR>", opts)
keymap("n", "<Down>", ":resize -2<CR>", opts)
keymap("n", "<Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Toggle relative numbers
keymap("n", "<leader>nr", ":set invrnu<CR>", opts)

-- Cycling through buffers
keymap("n", "<Tab>", ":bnext<CR>", opts)
keymap("n", "<S-Tab>", ":bprev<CR>", opts)

-- Kill buffer
keymap("n", "<leader>bk", ":bdelete<CR>", opts)


---------------------
-- Visual Mode (v) --
---------------------

-- Tabbing
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Moving lines around
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)


---------------------
-- Term Mode (t) --
---------------------

-- Escape term
keymap("t", "<Esc>", "<C-\\><C-n>", opts)
