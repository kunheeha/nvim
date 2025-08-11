return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            -- file selection
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-v>"] = actions.select_vertical,
            ["<C-s>"] = actions.select_horizontal,
            ["<C-t>"] = actions.select_tab,
            -- file preview
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
          },
        },
      },
      extensions = {
        -- fzf
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    -- load fzf extension
    require("telescope").load_extension("fzf")

    local find_files = function()
      builtin.find_files({
        find_command = {
          "rg",
          "--files",
          "--iglob",
          "!.git",
          "--hidden",
        },
      })
    end

    vim.keymap.set("n", "<leader>f", find_files, {})
    vim.keymap.set("n", "<C-g>", builtin.live_grep, {})
    vim.keymap.set("n", "<C-b>", builtin.buffers, {})
    vim.keymap.set("n", "<leader>h", builtin.help_tags, {})
    vim.keymap.set("n", "<leader>r", builtin.registers, {})
    vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, {})
  end,
}
