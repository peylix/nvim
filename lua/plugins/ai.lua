if Config.profile_is_reduced then return {} end

local map = vim.keymap.set
local add = vim.pack.add
local autocmd = vim.api.nvim_create_autocmd

-- copilot.lua
-- load it on demand
add({
  Config.gh("copilotlsp-nvim/copilot-lsp"),
  Config.gh("zbirenbaum/copilot.lua"),
}, { load = function() end })

autocmd("SourcePost", {
  group = Config.augr,
  pattern = "*/copilot.lua/plugin/*",
  once = true,
  callback = function()
    require("copilot").setup({
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = "<M-l>", -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
      disable_limit_reached_message = true,
    })

    autocmd("User", {
      group = Config.augr,
      pattern = "BlinkCmpMenuOpen",
      callback = function()
        vim.b.copilot_suggestion_hidden = true
      end,
    })

    autocmd("User", {
      group = Config.augr,
      pattern = "BlinkCmpMenuClose",
      callback = function()
        vim.b.copilot_suggestion_hidden = false
      end,
    })
  end,
})

-- sidekick.nvim
add({ Config.gh("folke/sidekick.nvim") })

require("sidekick").setup()

require("sidekick.nes").disable()

map({ "i", "n" }, "<Tab>", function()
  -- If there is a next edit, jump to it or apply it.
  if require("sidekick").nes_jump_or_apply() then return "" end

  -- Fallback to a literal Tab.
  return "<tab>"
end, {
  expr = true,
  desc = "Goto/Apply Next Edit Suggestion",
})

map({ "n", "t", "i", "x" }, "<C-.>", function()
  require("sidekick.cli").focus()
end, {
  desc = "Sidekick Focus",
})

map("n", "<leader>aa", function()
  require("sidekick.cli").toggle()
end, {
  desc = "Sidekick Toggle CLI",
})

map("n", "<leader>as", function()
  require("sidekick.cli").select()
  -- Or only installed tools:
  -- require("sidekick.cli").select({ filter = { installed = true } })
end, {
  desc = "Select CLI",
})

map("n", "<leader>ad", function()
  require("sidekick.cli").close()
end, {
  desc = "Detach a CLI Session",
})

map({ "x", "n" }, "<leader>at", function()
  require("sidekick.cli").send({ msg = "{this}" })
end, {
  desc = "Send This",
})

map("n", "<leader>af", function()
  require("sidekick.cli").send({ msg = "{file}" })
end, {
  desc = "Send File",
})

map("x", "<leader>av", function()
  require("sidekick.cli").send({ msg = "{selection}" })
end, {
  desc = "Send Visual Selection",
})

map({ "n", "x" }, "<leader>ap", function()
  require("sidekick.cli").prompt()
end, {
  desc = "Sidekick Select Prompt",
})
