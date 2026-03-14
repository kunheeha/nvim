return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "notes",
          path = "~/Notes",
        },
      },
      ui = { enable = false },
      legacy_commands = false,
      note_id_func = function(title)
        return title
      end,
    })

    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian open<CR>", opts)
    -- vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian today<CR>", opts)
    -- vim.keymap.set("n", "<leader>oy", "<cmd>Obsidian yesterday<CR>", opts)
    -- vim.keymap.set("n", "<leader>od", "<cmd>Obsidian dailies<CR>", opts)
    vim.keymap.set("n", "<leader>oc", "<cmd>Obsidian toggle_checkbox<CR>", opts)
    vim.keymap.set("n", "<CR>", function()
      if require("obsidian").util.cursor_on_markdown_link() then
        vim.cmd("Obsidian follow_link")
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
      end
    end, opts)
  end,
}
