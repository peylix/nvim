if Config.profile_is_reduced then return {} end

local map = vim.keymap.set

-- copilot.lua
-- vim.pack.add({
--   "https://github.com/copilotlsp-nvim/copilot-lsp",
--   "https://github.com/zbirenbaum/copilot.lua",
-- })
--
-- require("copilot").setup({
--   suggestion = {
--     enabled = not vim.g.ai_cmp,
--     auto_trigger = true,
--     hide_during_completion = vim.g.ai_cmp,
--     keymap = {
--       accept = "<M-l>", -- handled by nvim-cmp / blink.cmp
--       next = "<M-]>",
--       prev = "<M-[>",
--     },
--   },
--   panel = { enabled = false },
--   filetypes = {
--     markdown = true,
--     help = true,
--   },
--   disable_limit_reached_message = true,
-- })
--
-- Config.create_autocmd("User", "BlinkCmpMenuOpen", function()
--   vim.b.copilot_suggestion_hidden = true
-- end)
--
-- Config.create_autocmd("User", "BlinkCmpMenuClose", function()
--   vim.b.copilot_suggestion_hidden = false
-- end)

-- sidekick.nvim
vim.pack.add({ "https://github.com/folke/sidekick.nvim" })

require("sidekick").setup()

require("sidekick.nes").disable()

-- map({ "i", "n" }, "<Tab>", function()
--   -- If there is a next edit, jump to it or apply it.
--   if require("sidekick").nes_jump_or_apply() then return "" end
--
--   -- Fallback to a literal Tab.
--   return "<tab>"
-- end, {
--   expr = true,
--   desc = "Goto/Apply Next Edit Suggestion",
-- })

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
