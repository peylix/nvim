local map = vim.keymap.set
local add = vim.pack.add

-- neogit
local function neogit_config(fn)
  return function()
    add({
      Config.gh("folke/snacks.nvim"),
      Config.gh("neogitorg/neogit"),
    })

    require("neogit").setup({
      disable_line_numbers = false,
      disable_relative_line_numbers = false,
      graph_style = "kitty",
      commit_view = {
        kind = "auto",
      },
    })
    fn()
  end
end

map(
  "n",
  "<leader>gg",
  neogit_config(function()
    require("neogit").open({ kind = "split" })
  end),
  { desc = "Show Neogit UI" }
)

-- gitsigns.nvim
add({ Config.gh("lewis6991/gitsigns.nvim") })

local gitsigns = require("gitsigns")
gitsigns.setup({
  on_attach = function(bufnr)
    local function bmap(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      map(mode, l, r, opts)
    end

    -- Navigation
    bmap("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Go to next Git hunk" })

    bmap("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Go to previous Git hunk" })

    -- Actions
    bmap("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage Git hunk" })
    bmap("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset Git hunk" })

    bmap("v", "<leader>gs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage selected Git hunk" })

    bmap("v", "<leader>gr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset selected Git hunk" })

    bmap("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage Git buffer" })
    bmap("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset Git buffer" })
    bmap("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview Git hunk" })
    bmap(
      "n",
      "<leader>gk",
      gitsigns.preview_hunk_inline,
      { desc = "Preview Git hunk inline" }
    )

    bmap("n", "<leader>ga", function()
      gitsigns.blame_line({ full = true })
    end, { desc = "Show Git blame for line" })

    bmap("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff Git file" })

    bmap("n", "<leader>gD", function()
      gitsigns.diffthis("~")
    end, { desc = "Diff Git file against previous commit" })

    bmap("n", "<leader>gF", function()
      gitsigns.setqflist("all")
    end, { desc = "Add all Git hunks to quickfix" })
    bmap("n", "<leader>gf", gitsigns.setqflist, { desc = "Add Git hunks to quickfix" })

    -- Toggles
    bmap(
      "n",
      "<leader>gl",
      gitsigns.toggle_current_line_blame,
      { desc = "Toggle Git line blame" }
    )
    bmap("n", "<leader>gw", gitsigns.toggle_word_diff, { desc = "Toggle Git word diff" })
    bmap("n", "<leader>gL", gitsigns.blame, { desc = "Toggle blame view" })

    -- Text object
    bmap({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select Git hunk" })

    -- for mini.clue
    pcall(function()
      require("mini.clue").ensure_buf_triggers(bufnr)
    end)
  end,
})
