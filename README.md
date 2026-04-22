# PeylixNvim

My personal Neovim config.

## Dependencies

1. Neovim 0.12+
2. Git
3. ripgrep
4. Node.js & npm
5. Tree-sitter CLI
6. Nerd Font (for icons)
7. xclip (for clipboard support on Linux)
8. macism (for `im-select.nvim` on macOS)

## Reduced Profile

To start nvim with reduced config, run:

```shell
export PNVIM_PROFILE=reduced  # for bash/zsh
set -gx PNVIM_PROFILE reduced  # for fish
```

Or add it to the shell config file (e.g., `~/.bashrc`, `~/.zshrc`, `.config/fish/config.fsh`, etc.)
