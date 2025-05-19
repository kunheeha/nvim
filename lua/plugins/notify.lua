return {
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      background_colour = "#000000",
      top_down = false,
      stages = "fade_in_slide_out",
    })

    vim.notify = require("notify") -- make it the default notification handler
  end,
}
