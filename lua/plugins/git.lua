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
  { desc = "Show Neogit UI" }
)

-- gitsigns.nvim
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

local gitsigns = require("gitsigns")
gitsigns.setup({
  on_attach = function(bufnr)
    local function gsmap(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      map(mode, l, r, opts)
    end

    -- Navigation
    gsmap("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Go to next Git hunk" })

    gsmap("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Go to previous Git hunk" })

    -- Actions
    gsmap("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage Git hunk" })
    gsmap("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset Git hunk" })

    gsmap("v", "<leader>gs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage selected Git hunk" })

    gsmap("v", "<leader>gr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset selected Git hunk" })

    gsmap("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage Git buffer" })
    gsmap("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset Git buffer" })
    gsmap("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview Git hunk" })
    gsmap(
      "n",
      "<leader>gk",
      gitsigns.preview_hunk_inline,
      { desc = "Preview Git hunk inline" }
    )

    gsmap("n", "<leader>ga", function()
      gitsigns.blame_line({ full = true })
    end, { desc = "Show Git blame for line" })

    gsmap("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff Git file" })

    gsmap("n", "<leader>gD", function()
      gitsigns.diffthis("~")
    end, { desc = "Diff Git file against previous commit" })

    gsmap("n", "<leader>gF", function()
      gitsigns.setqflist("all")
    end, { desc = "Add all Git hunks to quickfix" })
    gsmap("n", "<leader>gf", gitsigns.setqflist, { desc = "Add Git hunks to quickfix" })

    -- Toggles
    gsmap(
      "n",
      "<leader>gl",
      gitsigns.toggle_current_line_blame,
      { desc = "Toggle Git line blame" }
    )
    gsmap("n", "<leader>gw", gitsigns.toggle_word_diff, { desc = "Toggle Git word diff" })
    gsmap("n", "<leader>gL", gitsigns.blame, { desc = "Toggle blame view" })

    -- Text object
    gsmap({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select Git hunk" })
  end,
})
