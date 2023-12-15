function SetColour(colour)
	colour = colour
  -- Solarized light
  if colour == 'solarized' then
    vim.opt.background = 'light'
    vim.g.solarized_italic_comments = true
    vim.g.solarized_italic_keywords = true
    vim.g.solarized_italic_functions = true
    vim.g.solarized_italic_variables = false
    vim.g.solarized_contrast = false
    vim.g.solarized_borders = true
    vim.g.solarized_disable_background = false

  else
    vim.opt.background = 'dark'

    -- Nord
    if colour == 'nord' then
      vim.opt.background = 'dark'
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true
      vim.g.nord_bold = true
      vim.g.nord_cursorline_tranparent = false
      vim.g.nord_uniform_diff_background = false

    -- Glacier
    elseif colour == 'glacier' then
      vim.opt.background = 'dark'
      vim.g.glacier_contrast = true
      vim.g.glacier_borders = true
      vim.g.glacier_disable_background = true
      vim.g.glacier_italic = true
      vim.g.glacier_bold = true
      vim.g.glacier_cursorline_tranparent = false
      vim.g.glacier_uniform_diff_background = false

    -- Catppuccin
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

    -- Kanagawa
    elseif colour == 'kanagawa' then
      require('kanagawa').setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true},
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
            palette = {},
            theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors) -- add/modify highlights
            return {}
        end,
        background = {
          dark = "wave",
          -- dark = "dragon",  -- Darker theme
          light = "lotus"
        }
      })

    -- Rose pine
    elseif colour == 'rose-pine' then
      require('rose-pine').setup({
        variant = 'auto',
        dark_variant = 'main',
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = true,
        disable_float_background = true,
        disable_italics = false,
        groups = {
          background = 'base',
          background_nc = '_experimental_nc',
          panel = 'surface',
          panel_nc = 'base',
          border = 'highlight_med',
          comment = 'muted',
          link = 'iris',
          punctuation = 'subtle',

          error = 'love',
          hint = 'iris',
          info = 'foam',
          warn = 'gold',

          headings = {
            h1 = 'iris',
            h2 = 'foam',
            h3 = 'rose',
            h4 = 'gold',
            h5 = 'pine',
            h6 = 'foam',
          }
          -- or set all headings at once
          -- headings = 'subtle'
        },
      })

    -- Solarized Dark
    elseif colour == 'neosolarized' then
      require('neosolarized').setup({
        comment_italics = true,
        background_set = false,
      })

    -- Gruvbox Material
    elseif colour == 'gruvbox-material' then
    end
  end

  -- Set Colourscheme
	vim.cmd.colorscheme(colour)

  -- override any cursoline settings in colourscheme
  vim.opt.cursorline = true
  vim.api.nvim_set_hl(0, 'CursorLine', { underline = true })
end

SetColour('rose-pine')
