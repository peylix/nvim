vim.pack.add({
  "https://github.com/yorumicolors/yorumi.nvim",
  "https://github.com/EdenEast/nightfox.nvim",
})

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

Config.create_autocmd(
  { "ColorScheme", "VimResume" },
  { pattern = "*", callback = sync_termbg, desc = "Sync terminal bg with colorscheme" }
)
Config.create_autocmd(
  { "VimLeavePre", "VimSuspend" },
  { pattern = "*", callback = reset_termbg, desc = "Reset terminal bg on exit/suspend" }
)

-- Sync immediately on startup
sync_termbg()
