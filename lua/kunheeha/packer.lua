vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

  use 'wbthomason/packer.nvim'

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  -- Telescope fzf native
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }

  -- Treesitter
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('nvim-treesitter/playground')

  -- NvimTree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    }
  }

  -- Colourschemes
  use 'kunheeha/nord.nvim' -- Nord
  use { "catppuccin/nvim", as = "catppuccin" }  -- Catppuccin
  use 'olivercederborg/poimandres.nvim' -- Poimandres
  use 'shaunsingh/solarized.nvim' -- Solarized light
  use 'rebelot/kanagawa.nvim' -- Kanagawa
  use 'kunheeha/glacier.nvim' -- Glacier

  -- LSP
  -- lsp-zero
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lua'},
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }

  -- Autopairs
  use 'jiangmiao/auto-pairs'
  
  -- Smoothscroll
  use 'karb94/neoscroll.nvim'

  -- VisIncr
  use 'vim-scripts/VisIncr'

  -- VimWiki
  use 'vimwiki/vimwiki'

  -- Lualine
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- Tabline
  use 'kdheepak/tabline.nvim'

  -- Notify
  use 'rcarriga/nvim-notify'

  -- Noice
  use {
    'folke/noice.nvim',
    requires = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' }
  }

  -- Useless package
  use 'eandrju/cellular-automaton.nvim'

  -- Colorizer
  use 'norcalli/nvim-colorizer.lua'

  -- Indent blankline
  use 'lukas-reineke/indent-blankline.nvim'

  -- HighStr
  use 'Pocco81/HighStr.nvim'

end)
