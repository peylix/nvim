-- highlight yanked lines
Config.create_autocmd("TextYankPost", "*", function()
  vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
end, "Highlight selection on yank")

-- User commands for vim.pack
vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update()
end, { desc = "Update plugins" })

vim.api.nvim_create_user_command("PackCheck", function()
  vim.pack.update(nil, { offline = true })
end, { desc = "Check for plugin states" })

-- Command for starting a headless Neovim server
local address_default = "127.0.0.1:5567"

-- use `:ServerStart [address]` to start a headless Neovim server that
-- listens on the specified [address]
-- if no [address] is provided, `address_default` will be used.
-- connect to the server with `nvim --server [address] --remote-ui`
-- or with `:connect [address]`
vim.api.nvim_create_user_command("ServerStart", function(opts)
  local address = opts.args ~= "" and opts.args or address_default
  vim.fn.jobstart({ "nvim", "--listen", address, "--headless" }, { detach = true })
  vim.notify("Headless server started on " .. address)
end, { nargs = "?", desc = "Start a headless Neovim server" })

-- Profile switching
local pnvim_profile = vim.env.PNVIM_PROFILE

Config.profile_name = (pnvim_profile == "reduced" or pnvim_profile == "default")
    and pnvim_profile
  or "default"
Config.profile_is_default = Config.profile_name == "default"
Config.profile_is_reduced = Config.profile_name == "reduced"

-- notify if it is in reduced mode
if Config.profile_is_reduced then
  vim.notify(
    "Neovim is running in reduced profile",
    vim.log.levels.WARN,
    { title = "Profile" }
  )
end
