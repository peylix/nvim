-- nvim-treesitter
local ts_update = function()
  vim.cmd("TSUpdate")
end
Config.on_packchanged("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})

-- nvim-lspconfig
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

-- mason.nvim
vim.pack.add({ "https://github.com/mason-org/mason.nvim" })

require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- for diagnostics icons
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  virtual_lines = {
    current_line = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN]  = "󰀪",
      [vim.diagnostic.severity.INFO]  = "󰋽",
      [vim.diagnostic.severity.HINT]  = "󰌶",
    },
  },
})

vim.lsp.enable({
  "basedpyright",
  "lua_ls",
  "clangd",
  "tinymist",
  "cssls",
  "html",
  "ts_ls",
})

vim.lsp.codelens.enable(true) -- enable codelens
vim.lsp.inlay_hint.enable(true) -- enable inlay hints
vim.lsp.semantic_tokens.enable(true) -- enable semantic tokens

-- nvim-lint
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

require("lint").linters_by_ft = {
  lua = { "selene" },
  python = { "ruff" },
}

-- conform.nvim
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
  default_format_opts = {
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff" },
  },
})
