vim.pack.add({
  "https://github.com/yorumicolors/yorumi.nvim",
  "https://github.com/EdenEast/nightfox.nvim",
})

-- use yorumi colorscheme
vim.cmd.colorscheme("yorumi")

-- Sync the terminal background with the current colorscheme with nvim_ui_send()
local function sync_termbg()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
  if normal.bg then
    vim.api.nvim_ui_send(string.format("\027]11;#%06x\007", normal.bg))
  end
end

local function reset_termbg()
  vim.api.nvim_ui_send("\027]111\027\\")
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimResume" }, {
  group = Config.augr,
  pattern = "*",
  callback = sync_termbg,
  desc = "Sync terminal bg with colorscheme",
})
vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
  group = Config.augr,
  pattern = "*",
  callback = reset_termbg,
  desc = "Reset terminal bg on exit/suspend",
})

-- Sync immediately on startup
sync_termbg()
