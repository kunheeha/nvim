require("twilight").setup({
  opts = {
    dimming = {
      alpha = 0.25,
      inactive = false,
    },
    context = 10,
    treesitter = true,
    expand = {
      "function",
      "method",
      "table",
      "if_statement",
    }
  },
  exclude = {},
})

vim.keymap.set("n", "<Leader>tw", vim.cmd.Twilight)
