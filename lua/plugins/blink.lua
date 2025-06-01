return {
  "saghen/blink.cmp",
  version = "1.*",
  --- @mondule "blink.cmp"
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      -- C-y to accept
      -- C-Space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/prev item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signaure.enabled = true)
      preset = "default"

      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- See :h blink-cmp-config-keymap for defining custom keymap
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
