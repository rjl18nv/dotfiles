local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
    return
end

ts_config.setup {
  ensure_installed = {
    "go",
    "graphql",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "lua",
    "python",
    "ruby",
    "rust",
    "tsx",
    "typescript",
    "yaml",
    "html",
    "toml",
    "vim"
  },
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  },
  context_commentstring = {
    enable = true
  }
}
