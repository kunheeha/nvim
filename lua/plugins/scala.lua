return {
  "scalameta/nvim-metals",
  ft = { "scala", "sbt" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = function()
    local metals_config = require("metals").bare_config()
    
    -- Use blink.cmp capabilities (matching other LSP configs)
    metals_config.capabilities = require('blink.cmp').get_lsp_capabilities()
    
    -- Settings from nvim-metals documentation
    metals_config.settings = {
      metals = {
        autoImportBuild = "auto",
        enableSemanticHighlighting = true,
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        superMethodLensesEnabled = true,
      },
    }
    
    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.ft,
      callback = function()
        require("metals").initialize_or_attach(metals_config)

        -- Ensure proper indentation settings for Scala
        vim.opt_local.expandtab = true      -- Convert tabs to spaces
        vim.opt_local.tabstop = 2           -- Tab = 2 spaces
        vim.opt_local.shiftwidth = 2        -- Indent = 2 spaces
        vim.opt_local.softtabstop = 2       -- Backspace removes 2 spaces
        vim.opt_local.autoindent = true     -- Copy indent from current line
        vim.opt_local.smartindent = false   -- Don't add extra indent logic

        -- Auto-format with scalafmt on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = vim.api.nvim_get_current_buf(),
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      end,
      group = nvim_metals_group,
    })
  end
}
