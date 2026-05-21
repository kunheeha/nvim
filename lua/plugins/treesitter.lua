return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  config = function()
    -- keep plugin for parser/query files + :TSInstall/:TSUpdate
    -- highlighting via built-in vim.treesitter (not plugin's highlight module)
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "vim", "vimdoc", "java", "latex", "bibtex", "go", "gomod", "gosum", "gowork" },
      sync_install = true,
      auto_install = true,
      highlight = { enable = false },
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("builtin_treesitter_hl", { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
