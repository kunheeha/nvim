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
      end,
      group = nvim_metals_group,
    })
  end
}
