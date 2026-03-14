return {
  "stevearc/aerial.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("aerial").setup({
      on_attach = function(bufnr)
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
    })

    local vault_path = vim.fn.expand("~/Notes")
    vim.keymap.set("n", "<leader>a", function()
      local buf_path = vim.fn.expand("%:p")
      if buf_path:find(vault_path, 1, true) == 1 then
        vim.cmd("Obsidian new")
      else
        vim.cmd("AerialToggle!")
      end
    end)
  end,
}
