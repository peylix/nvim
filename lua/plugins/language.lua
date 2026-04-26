local map = vim.keymap.set

-- nvim-treesitter
local ts_update = function()
  vim.cmd("TSUpdate")
end
Config.on_packchanged("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
})

local ts_parser_default = {
  "lua",
  "vim",
  "python",
  "javascript",
  "typescript",
  "html",
  "css",
  "c",
  "bash",
  "json",
  "comment",
}

local ts_parser_reduced = {
  "lua",
  "vim",
  "bash",
  "json",
  "comment",
}

-- get filetype names from treesitter parser names
local function parsers_to_filetypes(langs)
  local filetypes = {}
  for _, lang in ipairs(langs) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  return filetypes
end

local parsers = Config.profile_is_reduced and ts_parser_reduced or ts_parser_default
local filetypes = parsers_to_filetypes(parsers)

-- skip parser installation if tree-setter cli is not available
if vim.fn.executable("tree-sitter") == 1 then
  require("nvim-treesitter").install(parsers)
else
  vim.notify("Tree-sitter CLI not found. Skipping parser install.", vim.log.levels.WARN)
end

Config.create_autocmd("FileType", {
  pattern = filetypes,
  callback = function()
    -- enable highlighting
    local ok = pcall(vim.treesitter.start)
    if not ok then return end

    -- enable folds
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"

    -- enable indentation
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
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
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      -- [vim.diagnostic.severity.HINT] = "󰌶",
      [vim.diagnostic.severity.HINT] = "󰌵",
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
  "markdown_oxide",
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

-- VimTex
vim.pack.add({ "https://github.com/lervag/vimtex" })

vim.g.vimtex_view_method = "skim"
-- Snacks integration
map("n", "<localleader>lt", function()
  return require("vimtex.snacks").toc()
end, { desc = "Search in VimTex" })
