local actions = require('telescope.actions')
require('telescope').setup{
  pickers = {
    find_files = {
      hidden = true,
    }
  },
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
      }
    }
  },
  extensions = {
    -- fzf
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case"
    }
  }
}

-- Load fzf extension
require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>', builtin.find_files, {})
vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
vim.keymap.set('n', '<C-b>', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
