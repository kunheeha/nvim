local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

keymap("n", "<leader>f", vim.cmd.FloatermToggle, opts)
keymap("n", "<leader>fn", vim.cmd.FloatermNext, opts)
keymap("n", "<leader>fp", vim.cmd.FloatermPrev, opts)
keymap("n", "<leader>fc", ":FloatermNew --name=", opts)

-- vim.cmd([[hi Floaterm guibg=None]])
-- vim.cmd([[hi FloatermBorder guibg=None]])
