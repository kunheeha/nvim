return {
  "Pocco81/HighStr.nvim",
  config = function()
    local high_str = require("high-str")

    high_str.setup({
      verbosity = 0,
      saving_path = "/tmp/highstr",
      highlight_colors = {
        color_0 = { "#E5E9f0", "smart" },
        color_1 = { "#EBCB8B", "smart" },
        color_2 = { "#88C0D0", "smart" },
        color_3 = { "#B48EAD", "smart" },
        color_4 = { "#D08770", "smart" },
        color_5 = { "#A3BE8C", "smart" },
        color_6 = { "#5E81AC", "smart" },
        color_7 = { "#BF616A", "smart" },
        color_8 = { "#81A1C1", "smart" },
        color_9 = { "#8FBCBB", "smart" },
      },
    })

    for i = 0, 9 do
      vim.keymap.set("v", "<leader>hl" .. i, ":<c-u>HSHighlight " .. i .. "<CR>", { noremap = true, silent = true })
    end

    vim.keymap.set("n", "<leader>hlr", ":<c-u>HSRmHighlight rm_all<CR>", { noremap = true, silent = true })
  end,
}
