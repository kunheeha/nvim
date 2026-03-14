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

    local vault_path = vim.fn.expand("~/Notes")

    local function in_vault()
      local buf_path = vim.fn.expand("%:p")
      return buf_path:find(vault_path, 1, true) == 1
    end

    local find_files = function()
      if in_vault() then
        vim.cmd("Obsidian quick_switch")
      else
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
    end

    vim.keymap.set("n", "<leader>f", find_files, {})
    vim.keymap.set("n", "M", builtin.marks, {})
    vim.keymap.set("n", "<C-g>", function()
      if in_vault() then
        vim.cmd("Obsidian search")
      else
        builtin.live_grep()
      end
    end, {})
    vim.keymap.set("n", "<C-b>", function()
      if in_vault() then
        vim.cmd("Obsidian backlinks")
      else
        builtin.buffers()
      end
    end, {})
    vim.keymap.set("n", "<C-l>", function()
      if in_vault() then
        vim.cmd("Obsidian links")
      else
        vim.cmd("nohlsearch|diffupdate|normal! <C-L>")
      end
    end, {})
    vim.keymap.set("n", "<C-t>", function()
      if in_vault() then
        vim.cmd("Obsidian tags")
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-t>", true, false, true), "n", false)
      end
    end, {})
    vim.keymap.set("n", "<leader>h", builtin.help_tags, {})
    vim.keymap.set("n", "<leader>r", builtin.registers, {})
    vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, {})
  end,
}
