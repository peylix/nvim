# PeylixNvim

My personal Neovim config.

## Dependencies

1. Neovim 0.12+ (required by `vim.pack`, `ui2`, etc.)
2. Git
3. curl
4. ripgrep
5. Node.js & npm
6. Tree-sitter CLI
7. Nerd Font (for icons)
8. xclip (for clipboard support on Linux)
9. macism (for `im-select.nvim` on macOS)

## Reduced Profile

To start nvim with reduced config, run:

```shell
export PNVIM_PROFILE=reduced  # for bash/zsh
set -gx PNVIM_PROFILE reduced  # for fish
```

Or add it to the shell config file (e.g., `~/.bashrc`, `~/.zshrc`, `~/.config/fish/config.fish`, etc.)
