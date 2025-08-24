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

      -- Setup jdtls when Java files are opened
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          -- Check if jdtls is already running for this project
          local existing_clients = vim.lsp.get_clients({ name = "jdtls" })
          for _, client in ipairs(existing_clients) do
            if client.config.cmd and client.config.cmd[1] ~= "jdtls" then
              -- Custom jdtls client already exists, just attach to current buffer
              vim.lsp.buf_attach_client(0, client.id)
              return
            end
          end
          
          local project_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:h")
          local worktree_dir = vim.fn.fnamemodify(vim.fn.getcwd(), "p:h")
          local part1 = vim.fn.fnamemodify(project_dir, ":t")
          local part2 = vim.fn.fnamemodify(worktree_dir, ":t")
          local project_name = part1 .. "/" .. part2
          local workspace_dir = '/home/kunheeha/.javaprojects/' .. project_name
          local root_markers = {"pom.xml"}
          local root_dir = require("jdtls.setup").find_root(root_markers)
          
          local config = {
            cmd = {
              '/home/kunheeha/.local/share/nvim/mason/packages/jdtls/bin/jdtls',
              '--no-validate-java-version',
              '--java-executable', '/usr/lib/jvm/java-24-openjdk/bin/java',
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

          require("jdtls").start_or_attach(config)
        end,
      })
    end,
  }
}
