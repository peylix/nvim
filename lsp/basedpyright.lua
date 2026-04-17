return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        autoImportCompletions = true,
        typeCheckingMode = "standard",
        useLibraryCodeForTypes = false,
        autoSearchPaths = true,
        exclude = {
          "**/.venv",
          "**/.venv/**",
          "**/venv",
          "**/venv/**",
          "**/.pkl",
          "**/node_modules",
          "**/.next",
          "**/__pycache__",
          "**/.git",
          "**/dist/**",
          "**/build/**",
          "**/migrations",
          "**/.csv",
        },
      },
    },
  },
}
