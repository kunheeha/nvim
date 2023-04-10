function SetColour(colour)
	colour = colour
	if colour == 'nord' then
		vim.g.nord_contrast = true
		vim.g.nord_borders = true
		vim.g.nord_disable_background = true
		vim.g.nord_italic = true
		vim.g.nord_bold = true
		vim.g.nord_cursorline_tranparent = false
		vim.g.nord_uniform_diff_background = false
	elseif colour == 'catppuccin' then
		require('catppuccin').setup({
      flavour = 'mocha',
      transparent_background = true,
      show_end_of_buffer = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      styles = {
        comments = { 'italic' },
        conditionals = { 'italic' },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = {},
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = false,
        mini = false,
      },
		})
	end
	vim.cmd.colorscheme(colour)
  -- override any cursoline settings in colourscheme
  vim.opt.cursorline = true
  vim.api.nvim_set_hl(0, 'CursorLine', { underline = true })
  vim.opt.laststatus = 3
end

SetColour('nord')
