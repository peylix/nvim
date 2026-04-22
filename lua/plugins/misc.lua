-- buffer_manager
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/j-morano/buffer_manager.nvim",
})

require("buffer_manager").setup({})

-- im-select.nvim
-- must have macism installed
if Config.profile_is_default and vim.fn.has("mac") == 1 then
  vim.pack.add({ "https://github.com/keaising/im-select.nvim" })

  require("im_select").setup({
    default_im_select = "com.apple.keylayout.US",
    default_command = "macism",
    set_default_events = { "InsertLeave", "CmdlineLeave", "FocusGained" },
    set_previous_events = { "InsertEnter" },
    async_switch_im = true,
  })
end
