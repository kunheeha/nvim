return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      -- Global jdt:// URI handler
      vim.api.nvim_create_autocmd("BufReadCmd", {
        pattern = "jdt://*",
        callback = function(args)
          local clients = vim.lsp.get_clients({ name = "jdtls" })
          if #clients > 0 then
            require("jdtls").open_classfile(args.match)
          else
            vim.notify("jdtls client not ready", vim.log.levels.WARN)
          end
        end,
      })

      -- Global state for preventing duplicate jdtls calls
      local jdtls_hook_installed = false
      local original_lsp_start = nil
      
      -- Setup jdtls when Java files are opened
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          -- Check if jdtls is already running for this project
          local existing_clients = vim.lsp.get_clients({ name = "jdtls" })
          for _, client in ipairs(existing_clients) do
            if client.config.cmd and type(client.config.cmd) == "table" and client.config.cmd[1] ~= "jdtls" then
              -- Custom jdtls client already exists, just attach to current buffer
              vim.lsp.buf_attach_client(0, client.id)
              return
            end
          end
          
          local project_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:h")
          local worktree_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h")
          local part1 = vim.fn.fnamemodify(project_dir, ":t")
          local part2 = vim.fn.fnamemodify(worktree_dir, ":t")
          local project_name = part1 .. "/" .. part2
          local workspace_dir = '/Users/kunheeh/.javaprojects/' .. project_name
          local root_markers = {"pom.xml"}
          local root_dir = require("jdtls.setup").find_root(root_markers, vim.fn.getcwd())
          
          if not root_dir then
            vim.notify("Could not find Java project root", vim.log.levels.WARN)
            return
          end
          
          local config = {
            cmd = {
              '/Users/kunheeh/.local/share/nvim/mason/packages/jdtls/bin/jdtls',
              '--no-validate-java-version',
              '--java-executable', '/Users/kunheeh/.sdkman/candidates/java/21.0.4-amzn/bin/java',
              '-data', workspace_dir,
            },
            root_dir = root_dir,
            capabilities = require('blink.cmp').get_lsp_capabilities(),
            settings = {
              java = {
                eclipse = {
                  downloadSources = true,
                },
                maven = {
                  downloadSources = true,
                },
                references = {
                  includeDecompiledSources = true,
                },
                contentProvider = { 
                  preferred = "fernflower" 
                },
                import = {
                  maven = {
                    enabled = true
                  }
                },
                referencesCodeLens = {
                  enabled = true,
                },
                implementationsCodeLens = {
                  enabled = true,
                },
                sources = {
                  organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                  },
                },
              },
            },
            init_options = {
              bundles = {},
            },
          }

          -- Install global hook for vim.lsp.start to prevent duplicate jdtls calls
          if not jdtls_hook_installed then
            jdtls_hook_installed = true
            original_lsp_start = vim.lsp.start
            
            vim.lsp.start = function(lsp_config, lsp_opts)
              if type(lsp_config.cmd) == "table" and lsp_config.cmd[1] and lsp_config.cmd[1]:match("jdtls") then
                -- Block phantom client calls (cmd[1] == "jdtls")
                if lsp_config.cmd[1] == "jdtls" then
                  return nil
                end
                
                -- For custom calls without buffer info, add current buffer
                if not lsp_opts then
                  local current_bufnr = vim.api.nvim_get_current_buf()
                  lsp_opts = { bufnr = current_bufnr }
                end
              end
              
              return original_lsp_start(lsp_config, lsp_opts)
            end
          end
          
          require("jdtls").start_or_attach(config)

          -- Ensure attachment for first buffer (workaround for attachment issue)
          vim.defer_fn(function()
            local clients = vim.lsp.get_clients({ name = "jdtls" })
            if #clients > 0 and #vim.lsp.get_clients({ bufnr = 0 }) == 0 then
              vim.lsp.buf_attach_client(0, clients[1].id)
            end
          end, 2000)
        end,
      })
    end,
  }
}