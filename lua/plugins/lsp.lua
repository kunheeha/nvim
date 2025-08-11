return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp_attached", {clear = true}),
      callback = function(event)
        local opts = {buffer = event.buf}

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
        vim.keymap.set("n", "<C-s>", require("telescope.builtin").lsp_document_symbols, opts)
        vim.keymap.set("n", "gl", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, opts)
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    }

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- More aggressive jdtls prevention
    local lspconfig = require("lspconfig")
    lspconfig.jdtls.setup = function() end
    
    -- Auto-kill phantom jdtls clients
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.name == "jdtls" and client.config.cmd[1] == "jdtls" then
          print("Phantom jdtls client detected and stopped (id: " .. client.id .. ")")
          vim.schedule(function()
            client.stop()
          end)
        end
      end,
    })

    -- Override configs
    local servers = {
      -- gopls = {}
    }

    require("mason").setup({
      PATH = "skip"  -- Prevents Mason from adding jdtls to PATH
    })
    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          -- Skip jdtls - it's configured manually in java.lua
          if server_name == "jdtls" then
            return
          end
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end
      }
    })
  end,
}
