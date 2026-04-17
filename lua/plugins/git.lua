local map = vim.keymap.set

-- neogit
local function neogit_config(fn)
  return function()
    vim.pack.add({
      "https://github.com/nvim-lua/plenary.nvim",
      "https://github.com/esmuellert/codediff.nvim",
      "https://github.com/folke/snacks.nvim",
      "https://github.com/neogitorg/neogit",
    })

    require("neogit").setup({
      disable_line_numbers = false,
      disable_relative_line_numbers = false,
      graph_style = "kitty",
    })
    fn()
  end
end

map(
  "n",
  "<leader>gg",
  neogit_config(function()
    require("neogit").open()
  end),
  {desc="Show Neogit UI"}
)
