if Config.profile_is_reduced then return {} end

-- copilot.lua
vim.pack.add({
  "https://github.com/copilotlsp-nvim/copilot-lsp",
  "https://github.com/zbirenbaum/copilot.lua",
})

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
})

Config.create_autocmd("User", "BlinkCmpMenuOpen", function()
  vim.b.copilot_suggestion_hidden = true
end)

Config.create_autocmd("User", "BlinkCmpMenuClose", function()
  vim.b.copilot_suggestion_hidden = false
end)
