local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local add = vim.pack.add

-- nvim-treesitter
Config.on_packchanged("nvim-treesitter", { "update" }, function()
  vim.cmd("TSUpdate")
end, ":TSUpdate")

add({
  Config.gh("nvim-treesitter/nvim-treesitter"),
  Config.gh("nvim-treesitter/nvim-treesitter-textobjects"),
  Config.gh("nvim-treesitter/nvim-treesitter-context"),
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
  "markdown",
  "markdown_inline",
  "mermaid",
}

local ts_parser_reduced = {
  "lua",
  "vim",
  "bash",
  "json",
  "comment",
  "markdown",
  "markdown_inline",
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

autocmd("FileType", {
  group = Config.augr,
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
add({ Config.gh("neovim/nvim-lspconfig") })

-- mason.nvim
add({ Config.gh("mason-org/mason.nvim") })

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
  severity_sort = true,
  float = true,
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_lines = {
    current_line = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
})

vim.lsp.enable({
  "ty",
  "lua_ls",
  "clangd",
  "tinymist",
  "cssls",
  "html",
  "tsc",
  "jsonls",
})

vim.lsp.codelens.enable(true) -- enable codelens
vim.lsp.inlay_hint.enable(true) -- enable inlay hints
vim.lsp.semantic_tokens.enable(true) -- enable semantic tokens
vim.lsp.document_color.enable(true, nil, { style = "virtual" })

-- nvim-lint
add({ Config.gh("mfussenegger/nvim-lint") })

require("lint").linters_by_ft = {
  lua = { "selene" },
  python = { "ruff" },
  javascript = { "oxlint" },
  typescript = { "oxlint" },
}

-- conform.nvim
add({ Config.gh("stevearc/conform.nvim") })

require("conform").setup({
  default_format_opts = {
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff" },
    javascript = { "oxfmt" },
    typescript = { "oxfmt" },
    css = { "oxfmt" },
    html = { "oxfmt" },
    json = { "oxfmt" },
  },
})

-- Keymap for formatting
map("n", "<leader>lf", function()
  require("conform").format({ async = true })
end, { desc = "Format this buffer" })

-- render-markdown.nvim
autocmd("FileType", {
  group = Config.augr,
  pattern = "markdown",
  once = true,
  callback = function()
    add({
      Config.gh("nvim-treesitter/nvim-treesitter"),
      Config.gh("nvim-mini/mini.nvim"),
      Config.gh("MeanderingProgrammer/render-markdown.nvim"),
    })
    require("render-markdown").setup()
  end,
})

if not Config.profile_is_reduced then
  -- VimTex
  autocmd("FileType", {
    group = Config.augr,
    pattern = { "plaintex", "tex" },
    once = true,
    callback = function(args)
      add({
        Config.gh("lervag/vimtex"),
      })

      vim.g.vimtex_view_method = "skim"
      -- Snacks integration
      map("n", "<localleader>lt", function()
        return require("vimtex.snacks").toc()
      end, { desc = "Search in VimTex" })

      vim.api.nvim_exec_autocmds("FileType", { pattern = args.match })
    end,
  })

  -- typst-preview.nvim
  autocmd("FileType", {
    group = Config.augr,
    pattern = "typst",
    once = true,
    callback = function(args)
      add({
        {
          src = Config.gh("chomosuke/typst-preview.nvim"),
          version = vim.version.range("^1"),
        },
      })

      require("typst-preview").setup({
        dependencies_bin = { tinymist = "tinymist" },
      })
      vim.api.nvim_exec_autocmds("FileType", { pattern = args.match })
    end,
  })
end
