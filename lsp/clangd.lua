return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    -- "--header-insertion=never",
  },
  capabilities = {
    offsetEncoding = "utf-8",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git",
  },
}
