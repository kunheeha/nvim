-- lua/config/colours.lua
local M = {}

function M.set(colour)
  vim.opt.termguicolors = true

  if colour == "solarized" then
    vim.opt.background = "light"
    vim.g.solarized_italic_comments = true
    vim.g.solarized_italic_keywords = true
    vim.g.solarized_italic_functions = true
    vim.g.solarized_italic_variables = false
    vim.g.solarized_contrast = false
    vim.g.solarized_borders = true
    vim.g.solarized_disable_background = false

  else
    vim.opt.background = "dark"

    if colour == "nord" then
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true
      vim.g.nord_bold = true
      vim.g.nord_cursorline_tranparent = false
      vim.g.nord_uniform_diff_background = false

    elseif colour == "rose-pine" then
      require("rose-pine").setup({
        variant = "auto",
        dark_variant = "main",
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = true,
        disable_float_background = true,
        disable_italics = false,
        groups = {
          background = "base",
          background_nc = "_experimental_nc",
          panel = "surface",
          panel_nc = "base",
          border = "highlight_med",
          comment = "muted",
          link = "iris",
          punctuation = "subtle",
          error = "love",
          hint = "iris",
          info = "foam",
          warn = "gold",
          headings = {
            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
          },
        },
      })

    elseif colour == "neosolarized" then
      require("neosolarized").setup({
        comment_italics = true,
        background_set = false,
      })
    end
  end

  vim.cmd.colorscheme(colour)

  vim.opt.cursorline = true
  vim.api.nvim_set_hl(0, "CursorLine", { underline = true, sp = "#c4a7e7" })
end

return M
