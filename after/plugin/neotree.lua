require("neo-tree").setup({
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = true,
  filesystem = {
    follow_current_file = {
      enabled = true,
    },
    filtered_items = {
      visible = true,
      show_hidden_count = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    }
  },
  window= {
    position = "left",
    width = 40,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
  }
})

vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle<CR>")
