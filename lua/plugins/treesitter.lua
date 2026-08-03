return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "vim", "vimdoc", "java", "latex", "bibtex", "go", "gomod", "gosum", "gowork", "markdown", "markdown_inline" },
      sync_install = true,
      auto_install = true,
      highlight = { enable = true },
    })

    -- nvim-treesitter's markdown injection query uses #set-lang-from-info-string!
    -- which crashes during range-based parsing on certain files (nil node in
    -- get_range). Override with the bundled query that uses @injection.language.
    vim.treesitter.query.set("markdown", "injections", [[
      (fenced_code_block
        (info_string
          (language) @injection.language)
        (code_fence_content) @injection.content)

      ((html_block) @injection.content
        (#set! injection.language "html")
        (#set! injection.combined)
        (#set! injection.include-children))

      ((minus_metadata) @injection.content
        (#set! injection.language "yaml")
        (#offset! @injection.content 1 0 -1 0)
        (#set! injection.include-children))

      ((plus_metadata) @injection.content
        (#set! injection.language "toml")
        (#offset! @injection.content 1 0 -1 0)
        (#set! injection.include-children))

      ([
        (inline)
        (pipe_table_cell)
      ] @injection.content
        (#set! injection.language "markdown_inline"))
    ]])
  end,
}
