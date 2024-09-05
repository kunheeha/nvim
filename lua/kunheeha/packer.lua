vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

  use 'wbthomason/packer.nvim'

  -- Harpoon
  use {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    }
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.3',
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

  -- NeoTree
  use {
    'nvim-neo-tree/neo-tree.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    }
  }

  -- Arial
  use 'stevearc/aerial.nvim'

  -- Windowpicker (mainly for use with Neotree)
  use {
    's1n7ax/nvim-window-picker',
    tag = 'v2.*',
    config = function()
        require'window-picker'.setup()
    end,
  }
  -- Octo
  use {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim.telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    }
  }

  -- Sneak
  use 'justinmk/vim-sneak'

  -- Todo Comments
  use {
    'folke/todo-comments.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Surround
  use 'tpope/vim-surround'

  -- Colourschemes
  use 'kunheeha/nord.nvim' -- Nord
  use { "catppuccin/nvim", as = "catppuccin" }  -- Catppuccin
  use 'shaunsingh/solarized.nvim' -- Solarized light
  use 'rebelot/kanagawa.nvim' -- Kanagawa
  use 'kunheeha/glacier.nvim' -- Glacier
  use 'svrana/neosolarized.nvim' -- Solarized dark
  use { "rose-pine/neovim", as = "rose-pine" }
  use 'sainnhe/gruvbox-material' -- Gruvbox

  -- Colorbuddy
  use 'tjdevries/colorbuddy.nvim'

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

  -- GIT
  -- Gitsigns
  use 'lewis6991/gitsigns.nvim'
  -- Fugitive
  use 'tpope/vim-fugitive'
  -- Diffview
  use 'sindrets/diffview.nvim'

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
  use 'NvChad/nvim-colorizer.lua'

  -- Indent blankline
  use 'lukas-reineke/indent-blankline.nvim'

  -- HighStr
  use 'Pocco81/HighStr.nvim'

  -- Twilight
  use 'folke/twilight.nvim'

end)
