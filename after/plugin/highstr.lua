local high_str = require("high-str")

high_str.setup({
  verbosity = 0,
  saving_path = "/tmp/highstr",
  highlight_colors = {
    color_0 = {"#E5E9f0", "smart"},
    color_1 = {"#EBCB8B", "smart"},
    color_2 = {"#88C0D0", "smart"},
    color_3 = {"#B48EAD", "smart"},
    color_4 = {"#D08770", "smart"},
    color_5 = {"#A3BE8C", "smart"},
    color_6 = {"#5E81AC", "smart"},
    color_7 = {"#BF616A", "smart"},
    color_8 = {"#81A1C1", "smart"},
    color_9 = {"#8FBCBB", "smart"},
  }
})

vim.keymap.set('v', '<leader>hl0', ':<c-u>HSHighlight 0<CR>', { noremap=true, silent=true })
vim.keymap.set('v', '<leader>hl1', ':<c-u>HSHighlight 1<CR>', { noremap=true, silent=true })
vim.keymap.set('v', '<leader>hl2', ':<c-u>HSHighlight 2<CR>', { noremap=true, silent=true })
vim.keymap.set('v', '<leader>hl3', ':<c-u>HSHighlight 3<CR>', { noremap=true, silent=true })
vim.keymap.set('v', '<leader>hl4', ':<c-u>HSHighlight 4<CR>', { noremap=true, silent=true })
vim.keymap.set('v', '<leader>hl5', ':<c-u>HSHighlight 5<CR>', { noremap=true, silent=true })
vim.keymap.set('v', '<leader>hl6', ':<c-u>HSHighlight 6<CR>', { noremap=true, silent=true })
vim.keymap.set('v', '<leader>hl7', ':<c-u>HSHighlight 7<CR>', { noremap=true, silent=true })
vim.keymap.set('v', '<leader>hl8', ':<c-u>HSHighlight 8<CR>', { noremap=true, silent=true })
vim.keymap.set('v', '<leader>hl9', ':<c-u>HSHighlight 9<CR>', { noremap=true, silent=true })
vim.keymap.set('n', '<leader>rhl', ':<c-u>HSRmHighlight rm_all<CR>', { noremap=true, silent=true })
