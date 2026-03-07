-- Find the nearest ancestor directory containing a MODULE.bazel (Bazel monorepo root)
local function find_bazel_workspace(start_dir)
  local dir = start_dir
  while dir and dir ~= "/" do
    if vim.fn.filereadable(dir .. "/MODULE.bazel") == 1 then
      return dir
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return nil
end

-- Find the nearest ancestor directory containing a BUILD.bazel with Java targets
local function find_bazel_service_root(start_dir, workspace_root)
  local dir = start_dir
  while dir and dir ~= workspace_root and dir ~= "/" do
    if vim.fn.filereadable(dir .. "/BUILD.bazel") == 1 or vim.fn.filereadable(dir .. "/BUILD") == 1 then
      if vim.fn.filereadable(dir .. "/.classpath") == 1 then
        return dir
      end
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return nil
end

local script_path = vim.fn.stdpath("config") .. "/scripts/bazel-java-setup.sh"

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

      -- :BazelSetup command
      vim.api.nvim_create_user_command("BazelSetup", function(opts)
        local workspace_root = find_bazel_workspace(vim.fn.getcwd())
        if not workspace_root then
          vim.notify("Not in a Bazel workspace (no MODULE.bazel found)", vim.log.levels.ERROR)
          return
        end

        local project_path = opts.args
        if project_path == "" then
          -- Auto-detect from current file's directory
          local file_dir = vim.fn.expand("%:p:h")
          local dir = file_dir
          while dir and dir ~= workspace_root and dir ~= "/" do
            if vim.fn.filereadable(dir .. "/BUILD.bazel") == 1 or vim.fn.filereadable(dir .. "/BUILD") == 1 then
              project_path = dir:sub(#workspace_root + 2) -- strip workspace root + /
              break
            end
            dir = vim.fn.fnamemodify(dir, ":h")
          end
          if project_path == "" then
            vim.notify("Could not detect Bazel package from current file", vim.log.levels.ERROR)
            return
          end
        end

        local notify = require("notify")
        local notification = notify("BazelSetup: starting for " .. project_path .. "...", vim.log.levels.INFO, {
          title = "BazelSetup",
          timeout = false, -- persistent until replaced
        })

        vim.fn.jobstart({ "bash", script_path, workspace_root, project_path }, {
          stdout_buffered = false,
          stderr_buffered = false,
          on_stdout = function(_, data)
            for _, line in ipairs(data) do
              if line ~= "" then
                vim.schedule(function()
                  notification = notify("BazelSetup: " .. line, vim.log.levels.INFO, {
                    title = "BazelSetup",
                    replace = notification,
                    timeout = false,
                  })
                end)
              end
            end
          end,
          on_stderr = function(_, data)
            for _, line in ipairs(data) do
              if line ~= "" then
                vim.schedule(function()
                  notification = notify("BazelSetup: " .. line, vim.log.levels.WARN, {
                    title = "BazelSetup",
                    replace = notification,
                    timeout = false,
                  })
                end)
              end
            end
          end,
          on_exit = function(_, code)
            vim.schedule(function()
              if code == 0 then
                notify("BazelSetup complete!", vim.log.levels.INFO, {
                  title = "BazelSetup",
                  replace = notification,
                  timeout = 3000,
                })
                -- Stop existing jdtls clients and re-trigger setup
                for _, client in ipairs(vim.lsp.get_clients({ name = "jdtls" })) do
                  client:stop()
                end
                -- Re-trigger FileType autocmd to start jdtls with new classpath
                vim.defer_fn(function()
                  vim.cmd("doautocmd FileType java")
                end, 1000)
              else
                notify("BazelSetup failed (exit code " .. code .. ")", vim.log.levels.ERROR, {
                  title = "BazelSetup",
                  replace = notification,
                  timeout = 5000,
                })
              end
            end)
          end,
        })
      end, { nargs = "?", desc = "Generate .classpath/.project for a Bazel Java service" })

      -- :BazelClean command
      vim.api.nvim_create_user_command("BazelClean", function()
        local workspace_root = find_bazel_workspace(vim.fn.getcwd())
        if not workspace_root then
          vim.notify("Not in a Bazel workspace", vim.log.levels.ERROR)
          return
        end
        local service_root = find_bazel_service_root(vim.fn.expand("%:p:h"), workspace_root)
        if not service_root then
          vim.notify("No .classpath found in current service", vim.log.levels.WARN)
          return
        end
        os.remove(service_root .. "/.classpath")
        os.remove(service_root .. "/.project")
        vim.notify("Removed .classpath and .project from " .. service_root)
        for _, client in ipairs(vim.lsp.get_clients({ name = "jdtls" })) do
          client:stop()
        end
      end, { desc = "Remove generated Bazel Eclipse files and stop jdtls" })

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

          -- Detect project type and find root
          local cwd = vim.fn.getcwd()
          local root_dir = require("jdtls.setup").find_root({"pom.xml"}, cwd)
          local project_type = "maven"

          if not root_dir then
            -- Try Bazel: look for .classpath (generated by :BazelSetup)
            local workspace_root = find_bazel_workspace(cwd)
            if workspace_root then
              local service_root = find_bazel_service_root(vim.fn.expand("%:p:h"), workspace_root)
              if service_root then
                root_dir = service_root
                project_type = "bazel"
              else
                vim.notify("No .classpath found. Run :BazelSetup to generate it.", vim.log.levels.WARN)
                return
              end
            end
          end

          if not root_dir then
            vim.notify("Could not find Java project root", vim.log.levels.WARN)
            return
          end

          -- Compute workspace directory
          local workspace_dir
          if project_type == "maven" then
            local project_dir = vim.fn.fnamemodify(cwd, ":p:h:h")
            local worktree_dir = vim.fn.fnamemodify(cwd, ":p:h")
            local part1 = vim.fn.fnamemodify(project_dir, ":t")
            local part2 = vim.fn.fnamemodify(worktree_dir, ":t")
            workspace_dir = '/Users/kunheeh/.javaprojects/' .. part1 .. "/" .. part2
          else
            -- For Bazel, use the service directory name
            local service_name = vim.fn.fnamemodify(root_dir, ":t")
            workspace_dir = '/Users/kunheeh/.javaprojects/bazel-' .. service_name
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
