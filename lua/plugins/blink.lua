return {
  "saghen/blink.cmp",
  version = "1.*",
  --- @mondule "blink.cmp"
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      -- See :h blink-cmp-config-keymap for defining custom keymap
      preset = "none",

      ["<C-space>"] = { "select_and_accept" },
      ["<C-j>"] = { "select_next" },
      ["<C-k>"] = { "select_prev" },
      ["<C-e>"] = { "show", "show_documentation", "hide_documentation" },
      ["Down"] = { "scroll_documentation_down" },
      ["Up"] = { "scroll_documentation_up" },
    },

    appearance = {
      nerd_font_variant = "mono"
    },

    completion = {
      documentation = { auto_show = false },
    },

    sources = {
      default = { "lsp", "path", "buffer" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  },
}
