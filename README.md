# PeylixNvim

My personal Neovim config.

## Dependencies

1. Neovim 0.12+ (required by `vim.pack`, `ui2`, etc.)
2. `git`
3. `curl`
4. `ripgrep`
5. Tree-sitter CLI
6. Nerd Font (for icons)
7. Package managers like `npm`, `cargo`, etc. (for LSPs)
8. macism (for `im-select.nvim` on macOS)
9. xclip (for clipboard support on Linux)

## Reduced Profile

To start nvim with reduced config, run:

```shell
export PNVIM_PROFILE=reduced  # for bash/zsh, or
set -gx PNVIM_PROFILE reduced  # for fish
```

Or add it to the shell config file (e.g., `~/.bashrc`, `~/.zshrc`, `~/.config/fish/config.fish`, etc.)
