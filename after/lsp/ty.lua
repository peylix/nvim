---@type vim.lsp.Config
return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = {
    "ty.toml",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
  settings = {
    ty = {
      -- "openFilesOnly" | "workspace" | "off"
      diagnosticMode = "openFilesOnly",
      showSyntaxErrors = true,
      inlayHints = {
        variableTypes = true,
        callArgumentNames = true,
      },
      completions = {
        autoImport = true,
        completeFunctionParentheses = false,
      },
      configuration = {
        src = {
          exclude = {
            "**/.venv/",
            "**/venv/",
            "**/node_modules/",
            "**/__pycache__/",
            "**/.next/",
            "**/dist/",
            "**/build/",
            "**/migrations/",
          },
        },
      },
    },
  },
}
