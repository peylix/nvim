local map = vim.keymap.set

-- buffer_manager
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/j-morano/buffer_manager.nvim",
})

require("buffer_manager").setup({
  select_menu_item_commands = {
    v = {
      key = "<C-v>",
      command = "vsplit",
    },
    h = {
      key = "<C-h>",
      command = "split",
    },
  },
  focus_alternate_buffer = false,
  short_file_names = true,
  short_term_names = true,
  loop_nav = false,
  highlight = "Normal:BufferManagerBorder",
  win_extra_options = {
    winhighlight = "Normal:BufferManagerNormal",
  },
})

map("n", "<leader>bb", function()
  require("buffer_manager.ui").toggle_quick_menu()
end, { desc = "View all buffers" })

map("n", "]b", function()
  require("buffer_manager.ui").nav_next()
end, { desc = "Next buffer in buffer manager list" })

map("n", "[b", function()
  require("buffer_manager.ui").nav_prev()
end, { desc = "Previous buffer in buffer manager list" })

---- Navigate buffers bypassing the menu
local keys = "1234567890"
for i = 1, #keys do
  local key = keys:sub(i, i)
  map("n", string.format("<C-%s>", key), function()
    require("buffer_manager.ui").nav_file(i)
  end, { noremap = true })
end

---- Open menu and search
map({ "t", "n" }, "<leader>bs", function()
  require("buffer_manager.ui").toggle_quick_menu()
  -- wait for the menu to open
  vim.defer_fn(function()
    vim.fn.feedkeys("/")
  end, 50)
end, { noremap = true, desc = "Search in buffer menu" })

-- im-select.nvim
-- NOTE: make sure macism is installed
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

-- vim-startuptime
vim.pack.add({ "https://github.com/dstein64/vim-startuptime" })
