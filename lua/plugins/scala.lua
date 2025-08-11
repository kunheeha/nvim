return {
  "scalameta/nvim-metals",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "scala", "sbt" },
  opts = function()
    -- bare config
    local metals_config = require("metals").bare_config()
    -- LSP progress notifications showing on status bar
    -- NOTE: "on" NEEDS a settings to capture the notifications in the statusline
    -- "off" needs a plugin like fidget.nvim to handle the notifications
    metals_config.init_options.statusBarProvider = "off"

    -- On Attach function
    metals_config.on_attach = function (client, bufnr)
      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
      vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
      vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
      vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
      vim.keymap.set("n", "<C-s>", require("telescope.builtin").lsp_document_symbols, opts)
    end
    return metals_config
  end,
  config = function (self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.ft,
      callback = function ()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end
}
