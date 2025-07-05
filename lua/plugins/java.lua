return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function ()
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      local workspace_dir = '/Users/kunheeh/Projects/' .. project_name
      local root_markers = {"pom.xml"}
      local root_dir = require("jdtls.setup").find_root(root_markers)
      local config = {
        cmd = {
          -- Java Amazon Corrretto JDK 21.0.4 installed via sdkman
          '/Users/kunheeh/.sdkman/candidates/java/21.0.4-amzn/bin/java',

          '-Declipse.application=org.eclipse.jdt.ls.core.id1',
          '-Dosgi.bundles.defaultStartLevel=4',
          '-Declipse.product=org.eclipse.jdt.ls.core.product',
          '-Dlog.protocol=true',
          '-Dlog.level=ALL',
          '-Xmx1g',
          '--add-modules=ALL-SYSTEM',
          '--add-opens', 'java.base/java.util=ALL-UNNAMED',
          '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

          '-jar', '/Users/kunheeh/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.0.v20250331-1702.jar',

          '-configuration', '/Users/kunheeh/.local/share/nvim/mason/packages/jdtls/config_mac/',

          '-data', workspace_dir,
        },
        root_dir = root_dir,
      }

      require("jdtls").start_or_attach(config)
      
      vim.api.nvim_create_autocmd("BufReadCmd", {
        pattern = "jdt://*",
        callback = function (args)
          require("jdtls").ext.load_classfile(args)
        end,
      })
    end,
  }
}
