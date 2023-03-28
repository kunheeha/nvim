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
  use 'shaunsingh/nord.nvim'   -- Nord colourscheme
  use { "catppuccin/nvim", as = "catppuccin" }  -- Catppuccin colourscheme


end)
